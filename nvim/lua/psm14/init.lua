-- vim.opt.termguicolors = false
vim.opt.autoread = true
vim.opt.updatetime = 1000  -- Check every 1000ms (1 second)
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

-- Toggleterm-aider

-- Create aider terminal instance
local aider = Terminal:new({
  cmd = "aider --no-pretty --no-auto-commit --no-gitignore --watch-files",
  hidden = true,
  direction = "float",
})

-- Function to get current file path
local function get_current_file()
  return vim.fn.expand('%:p')
end

-- Function to add current file to aider
function _G.aider_add_file()
  local file = get_current_file()
  aider:send('/add ' .. file)
end

-- Function to drop current file from aider
function _G.aider_drop_file()
  local file = get_current_file()
  aider:send('/drop ' .. file)
end

-- Function to add file from nvim-tree
function _G.aider_add_tree_file()
  local node = require('nvim-tree.api').tree.get_node_under_cursor()
  if node then
    aider:send('/add ' .. node.absolute_path)
  end
end

-- Function to drop file from nvim-tree
function _G.aider_drop_tree_file()
  local node = require('nvim-tree.api').tree.get_node_under_cursor()
  if node then
    aider:send('/drop ' .. node.absolute_path)
  end
end

-- Aider terminal toggle
function _G.aider_toggle()
  aider:toggle()
  if aider:is_open() then
    vim.schedule(function()
      vim.cmd('startinsert')
    end)
  end
end

-- Function to handle aider file operations based on context
function _G.aider_smart_add()
  if vim.bo.filetype == 'NvimTree' then
    _G.aider_add_tree_file()
  else
    _G.aider_add_file()
  end
end

function _G.aider_smart_drop()
  if vim.bo.filetype == 'NvimTree' then
    _G.aider_drop_tree_file()
  else
    _G.aider_drop_file()
  end
end

-- Keymaps for aider
vim.keymap.set('n', '<D-k>', _G.aider_toggle, { desc = 'Toggle Aider terminal' })
vim.keymap.set('t', '<D-k>', '<C-\\><C-n>:lua aider_toggle()<CR>', { desc = 'Toggle Aider terminal' })
vim.keymap.set('n', '<leader>aa', _G.aider_smart_add, { desc = 'Add file to Aider' })
vim.keymap.set('n', '<leader>ad', _G.aider_smart_drop, { desc = 'Drop file from Aider' })

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

