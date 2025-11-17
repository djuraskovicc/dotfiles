-- General stuff
vim.g.loaded_netrw = 1              -- disable netrw file explorer
vim.g.loaded_netrwPlugin = 1        -- disable netrw file explorer plugin
vim.opt.backup = false              -- disable backup file creation
vim.opt.clipboard = "unnamedplus"   -- enable system clipboard access
vim.opt.conceallevel = 0            -- show concealed characters in markdown files
vim.opt.fileencoding = "utf-8"      -- set file encoding to UTF-8
vim.opt.mouse = ""                  -- Go hardcore mode! Disable mouse support
vim.opt.showmode = false            -- hide mode display
vim.opt.splitbelow = true           -- force horizontal splits below current window
vim.opt.splitright = true           -- force vertical splits right of current window
vim.opt.termguicolors = true        -- enable term GUI colors
vim.opt.timeoutlen = 500            -- set timeout for mapped sequences (500 ms)
vim.opt.updatetime = 50             -- set faster completion (50 ms)
vim.opt.writebackup = false         -- prevent editing of files being edited elsewhere
vim.opt.cursorline = true           -- highlight current line
vim.opt.cursorcolumn = true         -- highlight current column 
vim.opt.colorcolumn = '100'         -- color the right border of where my code should wrap around
vim.opt.guicursor = 'n-v-c-sm-i-ci-ve-r-cr-o:block'

-- Basic column settings
vim.opt.number = true               -- display line numbers
vim.opt.relativenumber = true       -- display relative line numbers
vim.opt.numberwidth = 2             -- set the width of line number column
vim.opt.signcolumn = "yes"          -- show side column
vim.opt.wrap = false                -- display lines as single line
vim.opt.scrolloff = 15              -- number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 20          -- number of columns to keep to the right and left of cursor

-- Tab spacing/behavior
vim.opt.expandtab = true            -- convert TAB to spaces
vim.opt.shiftwidth = 2              -- number of spaces inserted for each indentation level
vim.opt.shiftround = true           -- controls how indentation behaves when you use commands like >>, <<, or :>
vim.opt.tabstop = 2                 -- number of spaces inserted for TAB character
vim.opt.softtabstop = 2             -- number of spaces inserted for <TAB> key
vim.opt.smartindent = true          -- enable smart indentation
vim.opt.breakindent = true          -- enable line breaking indentation
vim.opt.backspace = "2"             -- configures behavior of backspace key

-- searching behaviors
vim.opt.hlsearch = true             -- highlight all matches in search
vim.opt.ignorecase = true           -- ignore case in search
vim.opt.smartcase = true            -- match case if explicitly stated

-- Command stuff
vim.opt.showcmd = true              -- shows commands when you type them
vim.opt.laststatus = 4              -- controls the status line visibility
vim.opt.autowrite = true            -- automatically writes changes to a file when (switching buffers, exiting nvim, running external command)
vim.opt.autoread = true             -- automatically reloads a file if it is modified outside neovim


