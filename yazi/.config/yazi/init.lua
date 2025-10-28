require("relative-motions"):setup({
	show_numbers = "relative",
	show_motion = true,
	only_motions = false,
})
require("duckdb"):setup({})
require("sshfs"):setup()
require("recycle-bin"):setup()
require("omp"):setup({ config = "/home/y2w8/.config/ohmyposh/mocha.omp.json" })
require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})
