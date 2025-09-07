return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",              -- latte, frappe, macchiato, mocha
      transparent_background = true,  -- disables setting the background color.
      no_italic = false,              -- Force no italic
      no_bold = false,                -- Force no bold
      no_underline = false,           -- Force no underline
      styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" },      -- Change the style of comments
        conditionals = { "italic" },
        loops = { "italic" },
        functions = { "bold" },
        numbers = { "bold" },
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
