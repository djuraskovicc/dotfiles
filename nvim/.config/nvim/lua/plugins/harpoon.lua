return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
      "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
    vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    for i = 1, 9, 1 do
      vim.keymap.set("n", "<leader>h" .. i, function() harpoon:list():select(i) end)
    end

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
end,}
