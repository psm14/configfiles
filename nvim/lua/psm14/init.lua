-- vim.opt.termguicolors = false
vim.opt.autoread = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.laststatus = 3

vim.g.mapleader = " " -- Set leader key before Lazy
 
require("psm14.lazy_init")

-- Keymaps
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', { desc = 'Move to down window' })
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', { desc = 'Move to up window' })
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', { desc = 'Move to right window' })

--vim.keymap.set('n', '<D-j>', ':belowright split term://zsh<CR>a', { desc = 'Open terminal' })
--vim.keymap.set('t', '<D-j>', '<C-\\><C-n>:q<CR>', { desc = 'Close terminal' })
--vim.cmd[[autocmd TermOpen * setlocal nonumber norelativenumber]]

-- Toggleterm
vim.keymap.set('n', '<D-j>', ':ToggleTerm<CR>', { desc = 'Open terminal' })
vim.keymap.set('t', '<D-j>', '<C-\\><C-n>:ToggleTerm<CR>', { desc = 'Close terminal' })

-- nvim-aider
vim.keymap.set('n', '<D-k>', ':AiderTerminalToggle<CR>', { desc = 'Open Aider' })
vim.keymap.set('t', '<D-k>', '<C-\\><C-n>:AiderTerminalToggle<CR>', { desc = 'Close Aider' })

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<D-p>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<D-S-p>', builtin.commands, { desc = 'Telescope commands' })
vim.keymap.set('n', '<D-S-f>', builtin.live_grep, { desc = 'Telescope live grep' })

-- nvim-tree
vim.keymap.set('n', '<D-b>', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })
