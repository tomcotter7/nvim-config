vim.opt.filetype = "on"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.title = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true

vim.opt.autoread = true

vim.opt.spelllang = "en_gb"

vim.opt.shellcmdflag = "-ic"

vim.opt.termguicolors = true

vim.opt.updatetime = 300

vim.opt.guicursor =
"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.filetype.add({
  filename = {
    ['requirements_dev.txt'] = 'requirements'
  },
  extension = {
    ['mojo'] = 'mojo'
  },
})
