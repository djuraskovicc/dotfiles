return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"bashls",
				"clangd",
				"pylsp",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()


			local default = { capabilities = capabilities }
			local servers = {
				rust_analyser = {
					capabilities = capabilities,
					filetypes = { "rust" },
					settings = {
						["rust_analyzer"] = {
							cargo = {
								allFeatures = true,
							},
						},
					},
				},
				pylsp = {
					plugins = {
						pycodestyle = {
							enabled = true,
							ignore = { "E501" },
						},
					},
				},
				lua_ls = default,
				clangd = default,
				bashls = default,
			}

			for name, config in pairs(servers) do
				vim.lsp.config(name, config)
				vim.lsp.enable(name)
			end

			vim.diagnostic.config({ virtual_text = true })
      vim.keymap.set("n", "<leader>tv", function()
        local cfg = vim.diagnostic.config()
        vim.diagnostic.config({ virtual_text = not cfg.virtual_text })
      end, { desc = "Toggle virtual text" })

			vim.keymap.set("n", "<leader>re", vim.lsp.buf.rename, { desc = "[R]ename Variable Globally" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
			vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation" })
			vim.keymap.set("n", "<leader>cg", vim.lsp.buf.definition, { desc = "[C]ode [G]oto Definition" })
			vim.keymap.set("n", "<leader>cd", vim.lsp.buf.declaration, { desc = "[C]ode [D]eclaration" })
			vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations, { desc = "[C]ode Goto [I]mplementation" })
			vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references, { desc = "[C]ode Goto [R]eferences" })
		end,
	},
}
