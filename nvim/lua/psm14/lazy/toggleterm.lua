return {
  'akinsho/toggleterm.nvim',
  config = function()
    require("toggleterm").setup {
      direction = "float",
      border = "single",
      start_in_insert = true,
      float_opts = {
        winblend = 3,
        width = function()
            return math.ceil(vim.o.columns * 0.83)
        end,
        height = function()
            return math.ceil(vim.o.lines * 0.83)
        end,
      }
    }
  end,
}
