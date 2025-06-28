-- vim.opt.termguicolors = false
vim.opt.autoread = true
vim.opt.updatetime = 1000  -- Check every 1000ms (1 second)
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.laststatus = 3

vim.g.mapleader = "\\" -- Set leader key before Lazy
 
require("psm14.lazy_init")

-- Keymaps
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', { desc = 'Move to down window' })
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', { desc = 'Move to up window' })
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', { desc = 'Move to right window' })

-- Toggleterm
local Terminal = require('toggleterm.terminal').Terminal
local default_term = Terminal:new({})

function _G.toggle_term()
  default_term:toggle()
  if default_term:is_open() then
    vim.schedule(function()
      vim.cmd('startinsert')
    end)
  end
end

vim.keymap.set('n', '<D-j>', _G.toggle_term, { desc = 'Toggle terminal' })
vim.keymap.set('t', '<D-j>', '<C-\\><C-n>:lua toggle_term()<CR>', { desc = 'Toggle terminal' })

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

-- Configure autoread to detect and reload files changed outside vim
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

