return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      ensure_installed = {
        "stylua",
        "prettier",
        "clang_format",
        "isort",
        "black",
      },
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.black,
      },
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}
