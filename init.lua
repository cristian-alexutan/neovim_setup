-- Set statusline with mode and file information
local current_mode = {
    n  = 'NORMAL ',
    v  = 'VISUAL ',
    V  = 'V·Line ',
    ["\22"] = 'V·Block ',  -- <C-V> (Ctrl+V)
    i  = 'INSERT ',
    R  = 'R ',
    Rv = 'V·Replace ',
    c  = 'Command ',
}

function StatuslineMode()
  local mode = vim.api.nvim_get_mode().mode  -- Get current mode
  return string.upper(current_mode[mode] or mode)
end

vim.opt.statusline = table.concat({
    "%{v:lua.StatuslineMode()}",
    "%F",
    "%=",
    "%l, %c      "
})

-- Set number and relative number
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable autoindent and autochdir
vim.opt.autoindent = true
vim.opt.autochdir = true

-- Set last status to 2 (always show statusline)
vim.opt.laststatus = 2

-- Don't show mode (since it's handled by statusline)
vim.opt.showmode = false

-- Tab and indentation settings
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Set scrolloff
vim.opt.scrolloff = 9

-- Save on Ctrl+S (Normal and Insert modes)
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true })

-- Plugin management using vim-plug
vim.cmd [[
  call plug#begin()
  
  " nvim-treesitter for syntax highlighting and code parsing
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " catppuccin theme
  Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

  call plug#end()
]]

-- Set colorscheme
vim.cmd [[colorscheme catppuccin-frappe]]

