return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = 20,
    open_mapping = [[<c-\>]],
    shade_terminals = true,
  },
  keys = {
    { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    {
      "<leader>tr",
      function()
        local file = vim.fn.expand("%:p")
        local ext = vim.fn.fnamemodify(file, ":e")
        local root = vim.fn.getcwd()
        local cmd = nil

        local function exec_cmd(c)
          require("toggleterm").exec(c, 1)
        end
        -- NOTE: add jdk version options and save configs in file
        -- detect gradle or maven wrapper
        local function build_tool()
          if vim.fn.filereadable(root .. "/gradlew") == 1 then
            return "./gradlew"
          elseif vim.fn.filereadable(root .. "/mvnw") == 1 then
            return "./mvnw"
          elseif vim.fn.filereadable(root .. "/build.gradle") == 1 then
            return "gradle"
          elseif vim.fn.filereadable(root .. "/pom.xml") == 1 then
            return "mvn"
          else
            return nil
          end
        end

        if ext == "py" then
          cmd = "python3 " .. file
        elseif ext == "c" then
          cmd = "gcc " .. file .. " -o out && ./out"
        elseif ext == "cpp" then
          cmd = "g++ -std=c++17 " .. file .. " -o out && ./out"
        elseif ext == "js" then
          cmd = "node " .. file
        elseif ext == "ts" then
          cmd = "ts-node " .. file
        elseif ext == "lua" then
          cmd = "lua " .. file
        elseif ext == "go" then
          cmd = "go run " .. file
        elseif ext == "rs" then
          cmd = "cargo run"
        elseif ext == "java" then
          vim.ui.select({ "Native", "Spring Boot", "JavaFX" }, {
            prompt = "Select Java Run Mode:",
          }, function(choice)
            if not choice then
              return
            end
            local bt = build_tool()
            if choice == "Native" then
              cmd = string.format("javac %s && java %s", file, vim.fn.expand("%:t:r"))
            elseif choice == "Spring Boot" then
              if bt and bt:match("gradle") then
                cmd = bt .. " bootRun"
              elseif bt and bt:match("mvn") then
                cmd = bt .. " spring-boot:run"
              else
                vim.notify("No Gradle/Maven build tool found", vim.log.levels.ERROR)
              end
            elseif choice == "JavaFX" then
              -- تحتاج تضبط PATH للـ JavaFX libs عندك
              cmd = string.format(
                "javac --module-path /path/to/javafx-sdk/lib --add-modules javafx.controls %s && java --module-path /path/to/javafx-sdk/lib --add-modules javafx.controls %s",
                file,
                vim.fn.expand("%:t:r")
              )
            end
            if cmd then
              exec_cmd(cmd)
            end
          end)
          return -- مهم علشان ما ينفذ exec_cmd(cmd) تحت
        else
          cmd = "./" .. file
        end

        if cmd then
          exec_cmd(cmd)
        else
          vim.notify("No run command for ." .. ext .. " files", vim.log.levels.WARN)
        end
      end,
      desc = "Run current file",
    },
  },
}
