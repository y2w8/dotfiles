local presets = require("markview.presets").headings

require("markview").setup {
  markdown = { headings = presets.arrowed },
}
