vim.g.mapleader = ''
vim.g.localleader = '\\'

-- vim.diagnostic.config({ virtual_text = true })

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
opt.spelloptions = "camel,noplainbuffer"
opt.spellsuggest = "best,6"

local lsp = vim.lsp

vim.lsp.config("*", {
  on_attach = on_attach
})

vim.lsp.config("roslyn", {
    settings = {
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,

            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
        },
        ["csharp|completion"] = {
          dotnet_show_name_completion_suggestions = true
        },
        ["csharp|formatting"] = {
          dotnet_organize_imports_on_format = true
        }
    },
})


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
{
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
},

{
    "seblyng/roslyn.nvim",
    ft = "cs",
      ---@module 'roslyn.config'
      ---@type RoslynNvimConfig
    opts = {
        -- your configuration comes here; leave empty for default settings
    },
},

{
  "folke/trouble.nvim",
  opts = {
    modes = {
      preview_float = {
        mode = "diagnostics",
        preview = {
          type = "float",
          relative = "editor",
          border = "rounded",
          title = "Preview",
          title_pos = "center",
          position = { 0, -2 },
          size = { width = 0.3, height = 0.3 },
          zindex = 200,
        },
      },
    },
  }, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
},
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

{
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

{
  'nvim-telescope/telescope.nvim', branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' }
},
{
    "rachartier/tiny-code-action.nvim",
    dependencies = {
        {"nvim-lua/plenary.nvim"},

        -- optional picker via telescope
        {"nvim-telescope/telescope.nvim"},
    },
    event = "LspAttach",
    opts = {},
},
{
  "nvim-tree/nvim-tree.lua",
  version = "*",
  Glazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  -- config = function()
  --   require("nvim-tree").setup {
  --
  --       view = {
  --         width = width
  --       }
  --   }
  -- end,
  keys = {
      { "<leader>nt", "<Cmd>NvimTreeToggle<CR>", "Toggle Tree" },
      { "<leader>nc", "<Cmd>NvimTreeToggle<CR>", "Show Clipboard" }
  }
},
})

vim.keymap.set({ "n", "x" }, "<leader>ca", function()
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true })

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

require("mason").setup({
registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    }
})
require("mason-lspconfig").setup()

-- Set width of Nvim-tree based on width of nvim window
local function width()
    local winwidth = vim.go.columns
    if winwidth <= 100 then
        return 30
    elseif winwidth <= 200 then
        return 40
    else
        return 50
    end
end


-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = width()
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
  { "<leader>ap", "<Cmd>MPRepl<CR>", desc = "Micropython Repl" }
  });

require('gitsigns').setup()
require("mini.comment").setup()
require("mini.surround").setup()
require("mini.statusline").setup()
require("mini.completion").setup()
require('mini.pairs').setup()
require("colorizer").setup()

require("telescope").setup({
    defaults = {
        file_ignore_patterns = { "%__virtual.cs$" },
    },
})

require("trouble").setup({
    modes = {
        diagnostics = {
            filter = function(items)
                return vim.tbl_filter(function(item)
                    return not string.match(item.basename, [[%__virtual.cs$]])
                end, items)
            end,
        },
    },
})


require('nightfox').setup({
  options = {
    transparent = true
  }
})

vim.cmd("colorscheme carbonfox")
