vim.g.mapleader = ''
vim.g.localleader = '\\'

vim.diagnostic.config({ virtual_text = true })

local opt = vim.opt

opt.autowrite = true -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3 -- global statusline
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = false -- Relative line numbers
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  -- fold = "⸱",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

opt.spell = true
opt.spelllang = "en"

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gR', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

-- setup compiler config for omnisharp
if client and client.name == "omnisharp" then
    -- nmap('gd', require('omnisharp_extended').lsp_definition, '[G]oto [D]efinition')
    -- nmap('gr', require('omnisharp_extended').lsp_references, '[G]oto [R]eferences')
    -- nmap('gI', require('omnisharp_extended').lsp_implementation, '[G]oto [I]mplementation')
    -- nmap('<leader>D', require('omnisharp_extended').lsp_type_definition, 'Type [D]efinition')

    nmap('gd', require('omnisharp_extended').telescope_lsp_definition({ jump_type = "vsplit" }), '[G]oto [D]efinition')
    nmap('gR', require('omnisharp_extended').telescope_lsp_references(), '[G]oto [R]eferences')
    nmap('gI', require('omnisharp_extended').telescope_lsp_implementation(), '[G]oto [I]mplementation')
    nmap('<leader>D', require('omnisharp_extended').lsp_type_definition(), 'Type [D]efinition')

end

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local lsp = vim.lsp

vim.lsp.config("*", {
  on_attach = on_attach
})

-- document existing key chains
-- require('which-key').register {
--   ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
--   ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
--   ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
--   ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
--   ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
--   ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
--   ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
-- }

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
{"EdenEast/nightfox.nvim"},
{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
{"williamboman/mason.nvim"},
{"williamboman/mason-lspconfig.nvim"},

{"neovim/nvim-lspconfig"},
{ 'echasnovski/mini.nvim', version = false },
{
  'catgoose/nvim-colorizer.lua',
  event = 'BufReadPre'

},
{"lewis6991/gitsigns.nvim"},
{"Hoffs/omnisharp-extended-lsp.nvim"},
{
    "jim-at-jibba/micropython.nvim",
    dependencies = { "akinsho/toggleterm.nvim", "stevearc/dressing.nvim" },
},
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
  }
},
  "folke/neodev.nvim",
  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
{
  "nvim-tree/nvim-tree.lua",
  version = "*",
  Glazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {}
  end,
  keys = {
      { "<leader>nt", "<Cmd>NvimTreeToggle<CR>", "Toggle Tree" },
      { "<leader>nc", "<Cmd>NvimTreeToggle<CR>", "Show Clipboard" }
  }
},
})

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

require("mason").setup()
require("mason-lspconfig").setup()

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

local wk = require('which-key')
wk.add({
  { "<leader>f", group = "Telescope" },
  { "<leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Buffers" },
  { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find File" },
  { "<leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Live Grep" },
  { "<leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Tags" },
  { "<leader>m", "<Cmd>Mason<CR>", desc = "Mason" },
  { "<leader>n", group = "Tree" },
  { "<leader>nc", "<Cmd>NvimTreeClipboard<CR>", desc = "Show Clipboard" },
  -- { "<leader>nt", "<Cmd>NvimTre<LeftMouse>Toggle<CR>", desc = "Toggle Tree" },
  { "<leader>v", "C-V", desc = "Stupid C-V Win Terminal Fix" },
  { "<leader>a", group = "Micropython" },
  { "<leader>ar", "<Cmd>MPRun<CR>", desc = "Micropython Run" },
  { "<leader>ap", "<Cmd>MPRepl<CR>", desc = "Micropython Repl" },
  });

require('gitsigns').setup()
require("mini.comment").setup()
require("mini.surround").setup()
require("mini.statusline").setup()
require("mini.completion").setup()
require("colorizer").setup()

require('nightfox').setup({
  options = {
    transparent = true
  }
})


vim.cmd("colorscheme carbonfox")
