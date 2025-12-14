-- Toggle Treesitter highlighting test file
-- English comments so it's clean for you

-- VARIABLES ------------------------------------------------------
local c
local my_var = 10           -- @variable
local _internal = 20        -- @variable.builtin
local function test_params(x, y) -- @variable.parameter
  local member = x.value    -- @variable.member
  return member + y
end

-- CONSTANTS ------------------------------------------------------
local PI = 3.14             -- @constant
local NULL = nil            -- @constant.builtin

-- MODULES / LABELS ----------------------------------------------
require("math")             -- @module

::label_here::              -- @label

-- STRINGS --------------------------------------------------------
local msg = "hello world"           -- @string
local doc = [[ This is a doc ]]     -- @string.documentation
local regex = "%d+"                 -- @string.regexp
local esc = "line\nbreak"           -- @string.escape
local url = "https://google.com"    -- @string.special.url

-- CHARACTERS ------------------------------------------------------
local ch = 'a'              -- @character

-- NUMBERS ---------------------------------------------------------
local num = 123             -- @number
local float = 1.23          -- @number.float

-- TYPES -----------------------------------------------------------
---@type string              -- @type
local typed = "yo"

---@class MyClass             -- @type.definition
local MyClass = {}

-- PROPERTIES ------------------------------------------------------
local obj = { value = 10 }  -- @property
print(obj.value)

-- FUNCTIONS -------------------------------------------------------
local function hello()       -- @function
  return "hi"
end

hello()                     -- @function.call

-- KEYWORDS --------------------------------------------------------
if true then                -- @keyword.conditional
  return                    -- @keyword.return
end

for i=1,10 do               -- @keyword.repeat
  c = i
end

-- OPERATORS -------------------------------------------------------
local sum = 1 + 2           -- @operator

-- PUNCTUATION -----------------------------------------------------
local tbl = {1, 2, 3}       -- @punctuation.bracket
local sep = 1, 2            -- @punctuation.delimiter

-- COMMENTS --------------------------------------------------------
-- normal comment             -- @comment
--- documentation             -- @comment.documentation

-- MARKUP (Markdown-like simulation) ------------------------------
-- **bold**                  -- @markup.strong
-- *italic*                  -- @markup.italic
-- ~~strike~~                -- @markup.strikethrough
-- # Heading                 -- @markup.heading

-- DIFF ------------------------------------------------------------
-- + added                   -- @diff.plus
-- - removed                 -- @diff.minus
-- ~ changed                 -- @diff.delta

-- TAGS ------------------------------------------------------------
-- <div>text</div>           -- @tag
-- class="x"                 -- @tag.attribute

-- YAML ------------------------------------------------------------
-- key: value                -- @label.yaml

-- HTML ------------------------------------------------------------
-- <a href="URL">Link</a>    -- @string.special.url.html

-- RUBY ------------------------------------------------------------
-- :symbol                   -- @string.special.symbol.ruby
return {
  tbl, sep, c, sum, typed, float, num, ch, url, PI,
  NULL, esc, regex, doc, msg, my_var, _internal,
  test_params(1, 2)

}
