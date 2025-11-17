return {
	{
		"nvim-mini/mini.nvim",
		version = false,
		config = function()
			local statusline = require("mini.statusline")
			statusline.setup({
				use_icons = true,
			})
		end,
	},
}
