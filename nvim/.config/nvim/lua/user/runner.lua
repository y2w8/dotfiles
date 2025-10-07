local M = {}
local uv = vim.loop
local config_file = ".build-config.json"
local Terminal = require("toggleterm.terminal").Terminal
-- دالة للتأكد إذا النيفيم (Neovim) شغال داخل Tmux
function M.in_tmux()
  return os.getenv("TMUX") ~= nil
end

-- دالة التشغيل الرئيسية
-- تستخدم Vimux إذا كنا في Tmux، وإلا بتستخدم Toggleterm
function M.run(cmd)
  if M.in_tmux() then
    local escaped_cmd = string.gsub(cmd, "'", "''")
    vim.cmd("VimuxInterruptRunner")
    vim.cmd("VimuxRunCommand('clear &&')")
    vim.cmd("VimuxRunCommand('clear && " .. escaped_cmd .. "')")
  else
    if not M.term then
      M.term = Terminal:new({ direction = "horizontal", hidden = true })
    end
    if not M.term:is_open() then
      M.term:open()
    end
    M.term:send("clear && " .. cmd)
  end
end

local function get_file_ext()
  return vim.fn.expand("%:e")
end

-- دالة مساعدة لتحديد مسار الملف بدون امتداد (للملفات القابلة للتنفيذ)
local function get_file_name_no_ext()
  return vim.fn.expand("%:r")
end

-- دالة مساعدة للحصول على مسار الملف الكامل
local function get_full_file_path()
  return vim.fn.expand("%:p")
end

-- دالة تشغيل / بناء ملفات C/C++
function M.cpp()
  local file = get_full_file_path()
  local out = get_file_name_no_ext()
  -- بناء وتشغيل: g++ <file> -o <out> && ./<out>
  M.run(string.format("g++ %s -o %s && ./%s", file, out, out))
end

-- دالة تشغيل ملفات Go
function M.go()
  M.run("go run " .. get_full_file_path())
end

-- دالة تشغيل ملفات Python
function M.python()
  M.run("python3 " .. get_full_file_path())
end

-- دالة تشغيل ملفات JavaScript
function M.js()
  M.run("node " .. get_full_file_path())
end

-- دالة تشغيل ملفات Rust
function M.rust()
  M.run("cargo run")
end

-- دالة تشغيل ملفات Lua
function M.lua()
  M.run("lua " .. get_full_file_path())
end

-- دالة تشغيل ملفات Shell Script
function M.sh()
  M.run("bash " .. get_full_file_path())
end

-- 🟢 Helper: read JSON config
local function load_config()
  local fd = io.open(config_file, "r")
  if not fd then
    return nil
  end
  local data = fd:read("*a")
  fd:close()
  local ok, decoded = pcall(vim.fn.json_decode, data)
  if ok then
    return decoded
  else
    return nil
  end
end

-- 🟢 Helper: save JSON config
local function save_config(tbl)
  local fd = io.open(config_file, "w")
  if not fd then
    return
  end
  fd:write(vim.fn.json_encode(tbl))
  fd:close()
end

-- 🟢 First time setup
local function setup_config(callback)
  local config = {}

  -- detect java versions from PATH
  local java_versions =
    vim.fn.systemlist("alternatives --display java | grep -o '/usr/lib[^ ]*/bin/java\\|/opt[^ ]*/bin/java' | sort -u")

  if #java_versions == 0 then
    java_versions = { "java" }
  end

  vim.ui.select(java_versions, { prompt = "Choose Java version:" }, function(choice)
    if not choice then
      return
    end
    config.java_bin = choice
    config.javac_bin = choice:gsub("java", "javac")

    vim.ui.input({ prompt = "📦 App Name: " }, function(app_name)
      config.app_name = app_name or "MyApp"

      vim.ui.input({ prompt = "🔄 Version: " }, function(version)
        config.version = version or "1.0.0"
        local mains = vim.fn.systemlist(
          "grep -R 'public static void main' src/main/java | awk -F: '{print $1}' | sed 's|^src/main/java/||; s|/|.|g; s|.java$||'"
        )
        vim.ui.select(mains, {
          prompt = "🎯 Select Main Class: ",
          format_item = function(item)
            return item -- ترجع العنصر نفسه بدون إضافة رقم
          end,
        }, function(main_class)
          config.main_class = main_class or "Main"
          vim.ui.input({ prompt = "👑 Vendor: " }, function(vendor)
            config.vendor = vendor or "Me"
            vim.ui.input({ prompt = "📝 Description: " }, function(desc)
              config.description = desc or config.app_name
              vim.ui.select({ "Maven", "Gradle", "Native" }, { prompt = "Build system?" }, function(pkg)
                config.package_choice = pkg or "Native"
                vim.ui.select({ "SpringBoot", "javafx", "Native" }, { prompt = "Framework?" }, function(framework)
                  config.framework = framework or "Native"
                  save_config(config)
                  callback(config)
                end)
              end)
            end)
          end)
        end)
      end)
    end)
  end)
end

-- 🟢 Run with existing config
local function run_with_config(cfg)
  local cmd = ""
  if cfg.package_choice == "Maven" and cfg.framework == "SpringBoot" then
    cmd = uv.fs_stat("mvnw") and "./mvnw spring-boot:run" or "mvn spring-boot:run"
  elseif cfg.package_choice == "Maven" and cfg.framework == "Native" then
    cmd = uv.fs_stat("mvnw") and "./mvnw exec:java" or "mvn exec:java"
  elseif cfg.package_choice == "Gradle" then
    cmd = uv.fs_stat("gradlew") and "./gradlew run" or "gradle run"
  elseif cfg.package_choice == "Native" then
    cmd = string.format("%s -cp target %s", cfg.java_bin, cfg.main_class)
  end

  M.run(cmd)
end

-- 🟢 Build with jpackage
local function build_with_jpackage(cfg, run)
  run = run or nil
  local package_type = "app-image"
  -- local cmd = string.format(
  --   "jpackage --name %s --input target --main-jar %s.jar --main-class %s --type %s --dest dist --vendor 'Me' --app-version %s --description '%s'",
  --   cfg.app_name,
  --   cfg.app_name,
  --   cfg.main_class,
  --   package_type,
  --   cfg.version,
  --   cfg.description
  -- )
  local original
  if cfg.framework == "SpringBoot" then
    original = ".original"
  else
    original = ""
  end
  local cmd_sequence = table.concat({
    -- 🧹 التنظيف
    "echo '🧹 Cleaning previous build...'",
    "&& rm -rf target lib dist",
    "&& mkdir -p lib dist",

    -- 🔨 البناء بـ Maven
    "&& echo '🔨 Building with Maven...'",
    string.format("&& mvn clean package -DskipTests=true -Dmaven.test.skip=true", cfg.app_name, cfg.version),
    -- 🆕 الخطوة الجديدة: الحصول على اسم ملف الـ JAR الوحيد
    "&& echo '🔍 Retrieving Executable JAR file name...'",
    -- هذا يضمن التقاط ملف الـ JAR الوحيد القابل للتنفيذ بعد Spring Boot
    string.format("&& JAR_FILE=$(ls target/*.jar | grep -v 'original' | xargs basename)%s", original),
    -- 📦 نسخ التبعيات (Dependencies)
    "&& echo '📦 Copying dependencies...'",
    "&& mvn dependency:copy-dependencies -DoutputDirectory=target/dependencies",
    "&& echo '📁 Copying JAR files to lib directory...'",
    "&& cp target/$JAR_FILE lib/", -- نقل الـ main JAR
    "&& cp target/dependencies/*.jar lib/", -- نقل التبعيات

    -- 📦 تشغيل jpackage
    string.format("&& jpackage --name '%s' ", cfg.app_name),
    string.format("--input lib "),
    string.format("--main-jar '$JAR_FILE' "),
    string.format("--main-class '%s' ", cfg.main_class),
    string.format("--type '%s' ", package_type),
    string.format("--dest ./dist "),
    string.format("--vendor '%s' ", cfg.vendor),
    string.format("--app-version '%s' ", cfg.version),
    string.format("--description '%s' ", cfg.description),
    string.format("&& echo '✅ Build successful! App in: ./dist/%s/'", cfg.app_name),
  }) -- نربط كل الأوامر بـ && عشان تتنفذ بالتسلسل
  M.run(cmd_sequence)
end

-- 🟢 Main entry point
function M.java()
  local cfg = load_config()
  if not cfg then
    setup_config(function(new_cfg)
      M.java()
    end)
    return
  end

  vim.ui.select({ "🚀 Run", "🛠️ Build", "📦 Build & Run", "⚙️ Edit Config" }, {
    prompt = "Main Option:",
    separator = "",
    layout_strategy = "center",
    layout_config = { height = 3, width = 30 },
    picker_opts = {
      layout_config = {
        height = 10,
        width = 30,
      },
      prompt_title = "",
      sorting_strategy = "ascending",
    },
  }, function(choice, index)
    if choice:match("Run") then
      run_with_config(cfg)
    elseif choice:match("Build") then
      build_with_jpackage(cfg)
    elseif choice:match("Build & Run") then
      build_with_jpackage(cfg)
      run_with_config(cfg)
    elseif choice:match("Edit Config") then
      setup_config(function(new_cfg)
        print("✅ Config updated!")
      end)
    end
  end)
end

-- الدالة الرئيسية والذكية للتشغيل التلقائي
function M.auto_run()
  local ext = get_file_ext()
  local file_path = get_full_file_path()

  if file_path == "" then
    print("💡 No file open to run.")
    return
  end

  if ext == "java" then
    M.java() -- نفتح قائمة الاختيار
  elseif ext == "py" then
    M.python()
  elseif ext == "js" then
    M.js()
  elseif ext == "rs" then
    M.rust()
  elseif ext == "go" then
    M.go()
  elseif ext == "c" or ext == "cpp" or ext == "cc" or ext == "cxx" then
    M.cpp()
  elseif ext == "lua" then
    M.lua()
  elseif ext == "sh" then
    M.sh()
  else
    -- تشغيل افتراضي لأي شي ثاني
    M.run(string.format("chmod +x %s && ./%s", file_path, file_path))
  end
end

return M

-- local M = {}
--
--

--

--
-- -- دالة اختيار وضعية تشغيل Java (مثل ما طلبت)
-- local function java_ui_select()
--   local file_path = get_full_file_path()
--   local classname = vim.fn.expand("%:t:r") -- اسم الملف بدون امتداد
--
--   -- 1. القائمة الرئيسية (الخيارات العامة)
--   local main_options = {
--     "Run Code", -- تشغيل مباشر للملف أو تنفيذه
--     "Build/Compile/Package", -- بناء الملفات القابلة للتنفيذ (JAR, executable)
--   }
--
--   vim.ui.select(main_options, { prompt = "Choose Java Action:" }, function(main_choice)
--     if not main_choice then
--       return
--     end -- إذا ألغى الاختيار
--     local package_options = {
--       "Native",
--       "Maven",
--       "Gradle",
--     }
--
--     vim.ui.select(package_options, { prompt = "Choose Java Packge:" }, function(package_choice)
--       if not package_choice then
--         return
--       end -- إذا ألغى الاختيار
--       if main_choice == main_options[1] then -- Run Code
--         -- 2. القائمة الفرعية لـ "Run Code"
--         local run_options
--         if package_choice == package_options[1] then
--         run_options = {
--
--           "Native", -- run
--           "Compile & Run", -- build to executable
--           -- "Run with Maven (mvn exec:java)",
--           -- "Run with Gradle (gradle run)",
--           -- "Run Spring Boot (mvn spring-boot:run)",
--           -- "Run JavaFX (Requires Path Config)",
--         }
--         end
--                 if package_choice == package_options[2] then
--         run_options = {
--
--           "Native", -- run
--           "SpringBoot", -- build to executable
--           -- "Run with Maven (mvn exec:java)",
--           -- "Run with Gradle (gradle run)",
--           -- "Run Spring Boot (mvn spring-boot:run)",
--           -- "Run JavaFX (Requires Path Config)",
--         }
--         end
--
--
--         vim.ui.select(run_options, { prompt = "Choose Run Method:" }, function(run_choice)
--           if not run_choice then
--             return
--           end
--
--           if run_choice == run_options[1] then -- Run Single File
--             if package_choice == package_options[1] then
--               M.run(string.format("java %s", file_path))
--             end
--             if package_choice == package_options[2] then
--               M.run("mvn exec:java")
--             end
--             if package_choice == package_options[3] then
--               M.run("gradle run")
--             end
--           elseif run_choice == run_options[2] then -- Compile & Run
--             if package_choice == package_options[1] then
--               M.run(string.format("javac %s && java %s", file_path, classname))
--             end
--             if package_choice == package_options[2] then
--               M.run("mvn clean package && mvn exec:java")
--             end
--             if package_choice == package_options[3] then
--               M.run("gradle build && gradle run")
--             end
--
--             -- elseif run_choice == run_options[3] then -- Maven
--             --     M.run("mvn clean package && mvn exec:java")
--             -- elseif run_choice == run_options[4] then -- Gradle
--             --     M.run("gradle build && gradle run")
--             -- elseif run_choice == run_options[5] then -- Spring Boot
--             --     M.run("mvn spring-boot:run")
--             -- elseif run_choice == run_options[6] then -- JavaFX
--             --     local java_version = "java"
--             --     M.run(
--             --       string.format("%s --module-path /path/to/javafx-sdk/lib --add-modules javafx.controls %s", java_version, file_path)
--             --     )
--           end
--         end)
--       elseif main_choice == main_options[2] then -- Build/Compile
--         -- 3. القائمة الفرعية لـ "Build/Compile"
--         local build_options = {
--           "Compile to Class File (.class)",
--           "Build to JAR (Standard)",
--           "Build with Maven (mvn clean package)",
--           "Build with Gradle (gradle build)",
--           "Build Executable with Jpackage (Manual)", -- تقدر تضيفها هنا
--         }
--         vim.ui.select(build_options, { prompt = "Choose Build Target:" }, function(build_choice)
--           if not build_choice then
--             return
--           end
--
--           if build_choice == build_options[1] then -- Compile to Class
--             M.run(string.format("javac %s", file_path))
--           elseif build_choice == build_options[2] then -- Build to JAR (مثال بسيط)
--             -- هذا مثال بسيط، بناء JAR يتطلب Manifest
--             M.run(string.format("jar cf %s.jar *.class", classname))
--           elseif build_choice == build_options[3] then -- Maven Package
--             M.run("mvn clean package")
--           elseif build_choice == build_options[4] then -- Gradle Build
--             M.run("gradle build")
--           end
--         end)
--       end
--     end)
--   end)
-- end
-- M.java = java_ui_select -- نربط الدالة بالـ module
--

--
--
--
-- return M
