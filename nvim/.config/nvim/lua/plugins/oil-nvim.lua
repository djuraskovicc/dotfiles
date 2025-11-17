return {
	"stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	lazy = false,
  config = function()
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end
}
