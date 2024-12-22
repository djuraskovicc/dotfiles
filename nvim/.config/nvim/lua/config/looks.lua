
-- set color of the line numbers
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#fcfc03' })
vim.api.nvim_set_hl(0, 'LineNr', { fg='#99ccfc' })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#c7c726' })

-- always fat cursor
vim.opt.guicursor = 'n-v-c-sm-i-ci-ve-r-cr-o:block'
