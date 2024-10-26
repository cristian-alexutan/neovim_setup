-- Set statusline with mode and file information
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.signcolumn = "yes"


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
vim.api.nvim_set_keymap('n', '<Tab>', '<C-w>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Plugin management using vim-plug
vim.cmd [[
  call plug#begin()

    Plug 'nvim-lualine/lualine.nvim'
  
    " nvim-treesitter for syntax highlighting and code parsing
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " catppuccin theme
    Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
    Plug 'sainnhe/gruvbox-material'

    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'neovim/nvim-lspconfig'

    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'

  call plug#end()
]]

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = { 'packer', 'NvimTree' },
      winbar = { 'packer', 'NvimTree' },
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- Set colorscheme
vim.cmd [[colorscheme gruvbox-material]]


-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})


-- Open nvim-tree automatically in new tabs
vim.api.nvim_create_autocmd("TabNew", {
  callback = function()
    -- Toggle nvim-tree in the new tab
    require("nvim-tree.api").tree.toggle({ focus = false })
  end
})

-- Ensure nvim-tree opens on the left in new tabs
vim.api.nvim_create_autocmd("TabEnter", {
  callback = function()
    -- If nvim-tree isn't open, open it
    if not require("nvim-tree.view").is_visible() then
      require("nvim-tree.api").tree.toggle({ focus = false })
    end
  end
})

-- Set up nvim-cmp.
 require'lspconfig'.pyright.setup{}
 require'lspconfig'.clangd.setup{}

local ELLIPSIS_CHAR = '…'
local MAX_LABEL_WIDTH = 25
local MAX_KIND_WIDTH = 14

local get_ws = function (max, len)
  return (" "):rep(max - len)
end

  local cmp = require'cmp'

  cmp.setup({
      formatting = {
          fields = { "abbr", "menu", "kind" },
    format = function(entry, item)
        -- Define menu shorthand for different completion sources.
        local menu_icon = {
            nvim_lsp = "NLSP",
            nvim_lua = "NLUA",
            luasnip  = "LSNP",
            buffer   = "BUFF",
            path     = "PATH",
        }
        -- Set the menu "icon" to the shorthand for each completion source.
        item.menu = menu_icon[entry.source.name]

        -- Set the fixed width of the completion menu to 60 characters.
        -- fixed_width = 20

        -- Set 'fixed_width' to false if not provided.
        fixed_width = fixed_width or false

        -- Get the completion entry text shown in the completion window.
        local content = item.abbr

        -- Set the fixed completion window width.
        if fixed_width then
            vim.o.pumwidth = fixed_width
        end

        -- Get the width of the current window.
        local win_width = vim.api.nvim_win_get_width(0)

        -- Set the max content width based on either: 'fixed_width'
        -- or a percentage of the window width, in this case 20%.
        -- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
        local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)

        -- Truncate the completion entry text if it's longer than the
        -- max content width. We subtract 3 from the max content width
        -- to account for the "..." that will be appended to it.
        if #content > max_content_width then
            item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
        else
            item.abbr = content .. (" "):rep(max_content_width - #content)
        end
        return item
        end,
      },
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]-- 

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }

  })

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['clangd'].setup {
    capabilities = capabilities
  }
