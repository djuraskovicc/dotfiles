-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Execute current line
vim.keymap.set("n", "<leader><leader>x", ":source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")

-- Spawn stuff
vim.keymap.set("n", "<leader>l", ":Lazy<CR>") -- spawn lazy
vim.keymap.set("n", "<leader>db", ":Dashboard<CR>") -- go to dashboard
vim.keymap.set("n", "<leader>mm", ":Mason<CR>") -- spawn mason

-- Basic functionality overriden
vim.keymap.set("n", "G", "Gzz") -- when you go to the end center the cursor
vim.keymap.set("n", "<leader>cs", ":nohlsearch<CR>") -- clear search

-- Hardcore mode: DISABLE arrow keys except command mode
vim.keymap.set({ "v", "i" }, "<left>", ":echo 'Use h to move!'<CR>")
vim.keymap.set({ "v", "i" }, "<right>", ":echo 'Use l to move!'<CR>")
vim.keymap.set({ "v", "i" }, "<down>", ":echo 'Use j to move!'<CR>")
vim.keymap.set({ "v", "i" }, "<up>", ":echo 'Use k to move!'<CR>")

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the down window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the up window" })

-- Stay visual mode while indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left in visual mode" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent left in visual mode" })

-- Visual yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highligh-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Sync with phone
local function sync_to_phone()
	local cwd = vim.fn.getcwd()
	local dir_name = vim.fn.fnamemodify(cwd, ":t")
	local remote_path = string.format("moto:~/projects/%s", dir_name)

	local cmd = string.format("rsync -az --inplace --delete '%s' '%s'", cwd, remote_path)
	local exit_code = os.execute(cmd)

	if exit_code == 0 then
		print("✅ Sync complete.")
	else
		print("❌ Sync failed.")
	end
end

vim.keymap.set("n", "<leader>sp", sync_to_phone)

-- Watch file changes
local sync_job = nil

local function toggle_sync()
	local cwd = vim.fn.getcwd()
	local dir = vim.fn.fnamemodify(cwd, ":t")
	local remote = string.format("moto:~/projects/%s", dir)

	if sync_job then
		vim.fn.jobstop(sync_job)
		sync_job = nil
		print("🛑 stopped sync for " .. dir)
	else
		local cmd = string.format(
			[[bash -c 'while inotifywait -r -e modify,create,delete,move "%s"; do rsync -az --delete "%s" "%s"; done']],
			cwd,
			cwd,
			remote
		)
		sync_job = vim.fn.jobstart(cmd, { detach = true })
		print("✅ started sync for " .. dir)
	end
end

vim.api.nvim_create_user_command("SyncToggle", toggle_sync, {})
vim.keymap.set("n", "<leader>st", ":SyncToggle<CR>")
