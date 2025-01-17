local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
 
require("lazy").setup({
    spec = "psm14.lazy",
    change_detection = { notify = false },
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json", -- move lockfile to XDG_DATA_HOME because nix store is readonly
})
