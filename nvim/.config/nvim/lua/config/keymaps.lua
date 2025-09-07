-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Spawn stuff
vim.keymap.set("n", "<leader>l", ":Lazy<CR>")       -- spawn lazy
vim.keymap.set("n", "<leader>db", ":Dashboard<CR>") -- go to dashboard
vim.keymap.set("n", "<leader>mm", ":Mason<CR>")     -- spawn mason

-- Basic functionality overriden
vim.keymap.set("n", "G", "Gzz")                                                        -- when you go to the end center the cursor
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")                                    -- clear search
vim.api.nvim_set_keymap("n", "<leader>w", "<C-W>w", { noremap = true, silent = true }) -- Change window

-- Hardcore mode: DISABLE arrow keys except command mode
vim.keymap.set({ "n", "v", "i" }, "<left>", "<cmd>echo 'Use h to move!'<CR>")
vim.keymap.set({ "n", "v", "i" }, "<right>", "<cmd>echo 'Use l to move!'<CR>")
vim.keymap.set({ "n", "v", "i" }, "<down>", "<cmd>echo 'Use j to move!'<CR>")
vim.keymap.set({ "n", "v", "i" }, "<up>", "<cmd>echo 'Use k to move!'<CR>")

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the down window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the up window" })

-- Stay visual mode while indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left in visual mode" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent left in visual mode" })

-- Sync with phone
local function sync_to_phone()
  local cwd = vim.fn.getcwd()
  local dir_name = vim.fn.fnamemodify(cwd, ":t")
  local remote_path = string.format("moto:~/arch-proot/root/Projects/%s", dir_name)

  local cmd = string.format("rsync -az --checksum --inplace --delete '%s' '%s'", cwd, remote_path)
  local exit_code = os.execute(cmd)

  if exit_code == 0 then
    print("✅ Sync complete.")
  else
    print("❌ Sync failed.")
  end
end

vim.keymap.set('n', '<leader>rs', sync_to_phone)

-- Watch file changes
local sync_job = nil

local function toggle_sync()
  local cwd = vim.fn.getcwd()
  local dir = vim.fn.fnamemodify(cwd, ":t")
  local remote = string.format("moto:~/arch-proot/root/Projects/%s", dir)

  if sync_job then
    vim.fn.jobstop(sync_job)
    sync_job = nil
    print("🛑 stopped sync for " .. dir)
  else
    local cmd = string.format(
      [[bash -c 'while inotifywait -r -e modify,create,delete,move "%s"; do rsync -az --checksum --delete "%s/" "%s"; done']],
      cwd, cwd, remote
    )
    sync_job = vim.fn.jobstart(cmd, { detach = true })
    print("✅ started sync for " .. dir)
  end
end

vim.api.nvim_create_user_command("SyncToggle", toggle_sync, {})
vim.keymap.set('n', '<leader>s', ":SyncToggle<CR>")

