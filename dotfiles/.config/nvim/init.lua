--[[ Basic Keymaps ]]
-- https://learnxinyminutes.com/docs/lua/
-- https://neovim.io/doc/user/lua-guide.html

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Git related plugins
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require("fidget").setup({})`
      { "j-hui/fidget.nvim",       opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
    },
  },

  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",

      -- Adds a number of user-friendly snippets
      "rafamadriz/friendly-snippets",
    },
  },

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', '<leader>hs', gs.stage_hunk, { desc = "stage hunk" })
        map('n', '<leader>hr', gs.reset_hunk, { desc = "reset hunk" })

        map('v', '<leader>hs', function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = "stage hunk" })

        map('v', '<leader>hr', function()
          gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = "reset hunk" })

        map('n', '<leader>hS', gs.stage_buffer, { desc = "stage buffer" })
        map('n', '<leader>hR', gs.reset_buffer, { desc = "reset buffer" })
        map('n', '<leader>hp', gs.preview_hunk, { desc = "preview hunk" })
        map('n', '<leader>hi', gs.preview_hunk_inline, { desc = "preview hunk inline" })

        map('n', '<leader>hb', function()
          gs.blame_line({ full = true })
        end, { desc = "blame line" })

        map('n', '<leader>hd', gs.diffthis)

        map('n', '<leader>hD', function()
          gs.diffthis('~')
        end, { desc = "diff this" })

        map('n', '<leader>hQ', function() gs.setqflist('all') end)
        map('n', '<leader>hq', gs.setqflist, { desc = "setqflist" })

        -- Toggles
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "toggle current line blame" })
        map('n', '<leader>td', gs.toggle_deleted, { desc = "toggle deleted" })
        map('n', '<leader>tW', gs.toggle_word_diff, { desc = "toggle word diff" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
      end,
    },
  },
  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "monokai-pro"
    end
  },
  { "nvim-neotest/nvim-nio" },
  {
    "williamboman/mason.nvim",

    "mfussenegger/nvim-dap",
    "jay-babu/mason-nvim-dap.nvim",
    "HiPhish/debugpy.nvim",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",

    "mfussenegger/nvim-lint",
    "rshkarin/mason-nvim-lint",
  },
  {
    "ThePrimeagen/vim-be-good",
    "norcalli/nvim-colorizer.lua",
    "ziontee113/color-picker.nvim",
  },
  {
    "echasnovski/mini.icons",
    opts = {},
    lazy = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = "monokai-pro",
        component_separators = "|",
        section_separators = "",
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- See `:help ibl`
    main = "ibl",
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  {
    "numToStr/Comment.nvim",
    opts = {
      toggler = {
        ---Line-comment toggle keymap
        line = "gj",
        ---Block-comment toggle keymap
        block = "gbc",
      },
      opleader = {
        ---Line-comment keymap
        -- line = "<C-KP_Divide>",
        line = "gj",
        ---Block-comment keymap
        block = "gb",
      },
    }
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
  },
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = "custom.plugins" },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
vim.g.python3_host_prog = "/usr/bin/python3.13"

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
vim.o.termguicolors = true

-- Neovide
-- Put anything you want to happen only in Neovide here
if vim.g.neovide then
  -- nvim ginit.vim
  -- map! <S-Insert> <C-R>+
  --
  -- vim.g.neovide_profiler = true
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_vfx_mode = "sonicboom"
  vim.o.guifont = "Monospace:h14"
  -- vim.o.guifont = "Noto Mono:h14"
  -- vim.o.guifont = "JetBrains Mono:h12"
end

-- [[Custom Options]]
vim.o.relativenumber = true
vim.o.textwidth = 180
vim.o.clipboard = "unnamedplus"
vim.o.wrap = false
vim.o.scrolloff = 8
vim.o.smartindent = true
vim.o.magic = true

-- Disable swap files
vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = false

-- caret Multi Caret https://github.com/mg979/vim-visual-multi
-- [[ Basic Keymaps ]] bindings Bindings keymaps custom keymaps custom bindings
vim.keymap.set({ "n", "v", "t", "i" }, "<C-A-w>", "<esc><cmd>:lua require'dapui'.close()<cr>:q<cr>", { desc = "Quit" })
vim.keymap.set({ "n", "v", "t", "i" }, "<C-s>", "<cmd>:wa<cr>", { desc = "Save [A]ll" })
vim.keymap.set({ "n", "v", "t", "i" }, "<C-e>", "<cmd>:Neotree toggle<cr>", { desc = "Toggle Tre[E]" })
vim.keymap.set("i", "jk", "<esc>", { desc = "jk esc" })
vim.keymap.set("n", "<A-S-f>", ":Format <cr>:!black %<cr><enter>", { desc = "Format file" })
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })
vim.keymap.set({ "n", "v" }, "<A-S-j>", ":yank<cr>p", { desc = "Copy line down" })
vim.keymap.set("n", "<C-.>", ":lua vim.lsp.buf.code_action()<cr>", { desc = "Code Actions" })
vim.keymap.set("n", "<leader><cr>", ":so ~/.config/nvim/init.lua<cr>", { desc = "Source init.lua" })
vim.keymap.set("n", "<leader>r", ":reg<cr>", { desc = "[R]egisters" })
vim.keymap.set("n", "<leader>hc", ":Git diff<cr>", { desc = "changes" })
vim.keymap.set("n", "<leader>gs", ":Telescope git_status<cr>", { desc = "[S]tatus" })
vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<cr>", { desc = "[B]ranches" })
vim.keymap.set("n", "<leader>gc", ":Telescope git_commits<cr>", { desc = "[C]ommits" })
vim.keymap.set("n", "<leader>gx", ":Telescope git_stash<cr>", { desc = "stash[X]" })
vim.keymap.set("n", "<leader>gh", ":Telescope git_bcommits<cr>", { desc = "[H]istory" })
-- vim.keymap.set('n', '<F13>', require('Comment.api').toggle.linewise.current, { noremap = true, silent = true })

-- Plugins keymaps?
vim.keymap.set("n", "cp", "<cmd>PickColor<cr>", { desc = "[C]olor [P]ick" })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Spellcheck spellcheck spell check
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "markdown" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en_us" }
  end,
})

vim.keymap.set("n", "<leader>ts", function()
  vim.opt.spell = not vim.opt.spell:get()
  print("Spell check: " .. (vim.opt.spell:get() and "ON" or "OFF"))
end, { desc = "[S]pell check" })
-- highlight SpellBad cterm=underline gui=undercurl guisp=Red

-- Quick fix
local function quickfix()
  vim.lsp.buf.code_action({
    filter = function(a) return a.isPreferred end,
    apply = true
  })
end

vim.keymap.set('n', '<leader>Qf', quickfix, { noremap = true, silent = true })
local wk = require("which-key")
wk.add({ "<leader>Qf", group = "[Q]uick [F]ix", mode = "n" })

-- Word Wrap word wrap
vim.keymap.set("n", "<leader>tw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
  print("Word wrap: " .. (vim.opt.wrap:get() and "ON" or "OFF"))
end, { desc = "Word [W]rap" })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- [[ Configure Monokai-Pro ]]
require("monokai-pro").setup({
  transparent_background = false,
  terminal_colors = true,
  devicons = true, -- highlight the icons of `nvim-web-devicons`
  styles = {
    comment = { italic = true },
    keyword = { italic = true },       -- any other keyword
    type = { italic = true },          -- (preferred) int, long, char, etc
    storageclass = { italic = true },  -- static, register, volatile, etc
    structure = { italic = true },     -- struct, union, enum, etc
    parameter = { italic = true },     -- parameter pass in function
    annotation = { italic = true },
    tag_attribute = { italic = true }, -- attribute of tag in reactjs
  },
  -- filter = "spectrum",                 -- classic | octagon | pro | machine | ristretto | spectrum
  filter = "octagon", -- classic | octagon | pro | machine | ristretto | spectrum
  -- Enable this will disable filter option
  day_night = {
    enable = false,            -- turn off by default
    day_filter = "pro",        -- classic | octagon | pro | machine | ristretto | spectrum
    night_filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
  },
  inc_search = "background",   -- underline | background
  background_clear = {
    "toggleterm",
    "telescope",
    "which-key",
    "renamer",
    "notify",
    "neo-tree",
  },
  plugins = {
    bufferline = {
      underline_selected = false,
      underline_visible = false,
    },
    indent_blankline = {
      context_highlight = "default", -- default | pro
      context_start_underline = false,
    },
  },
  override = function(c) end,
})

require("colorizer").setup()
require("color-picker").setup()

require("neo-tree").setup({
  close_if_last_window = true,
  window = {
    position = "left",
    width = 40,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      ["<space>"] = {
        "toggle_node",
        nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
      },
      ["<2-LeftMouse>"] = "open",
      ["<cr>"] = "open",
      ["<esc>"] = "cancel", -- close preview or floating neo-tree window
      ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
      -- Read `# Preview Mode` for more information
      ["l"] = "focus_preview",
      ["S"] = "open_split",
      ["s"] = "open_vsplit",
      ["t"] = "open_tabnew",
      ["w"] = "open_with_window_picker",
      ["C"] = "close_node",
      ["z"] = "close_all_nodes",
      ["Z"] = "expand_all_nodes",
      ["a"] = {
        "add",
        config = {
          show_path = "none" -- "none", "relative", "absolute"
        }
      },
      ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
      ["d"] = "delete",
      ["<F2>"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
      -- ["c"] = {
      --  "copy",
      --  config = {
      --    show_path = "none" -- "none", "relative", "absolute"
      --  }
      --}
      ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
      ["q"] = "close_window",
      ["R"] = "refresh",
      ["?"] = "show_help",
      ["<"] = "prev_source",
      [">"] = "next_source",
      ["i"] = "show_file_details",
    }
  },
  filesystem = {
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    follow_current_file = {
      enabled = true,          -- This will find and focus the file in the active buffer every time
      --               -- the current file is changed while the tree is open.
      leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
    window = {
      mappings = {
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["/"] = "fuzzy_finder",
        ["D"] = "fuzzy_finder_directory",
        ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
        ["f"] = "filter_on_submit",
        ["<c-x>"] = "clear_filter",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",
        ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
        ["oc"] = { "order_by_created", nowait = false },
        ["od"] = { "order_by_diagnostics", nowait = false },
        ["og"] = { "order_by_git_status", nowait = false },
        ["om"] = { "order_by_modified", nowait = false },
        ["on"] = { "order_by_name", nowait = false },
        ["os"] = { "order_by_size", nowait = false },
        ["ot"] = { "order_by_type", nowait = false },
      },
    },
  },
})

-- Log Level
-- vim.lsp.set_log_level("debug")

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer"s path
local function find_git_root()
  -- Use the current buffer"s path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file"s path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file"s path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print "Not a git repository. Searching on current working directory"
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require("telescope.builtin").live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = "[/] Fuzzily search in current buffer" })

local function telescope_live_grep_open_files()
  require("telescope.builtin").live_grep {
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  }
end
vim.keymap.set("n", "<leader>f/", telescope_live_grep_open_files, { desc = "[F]ind [/] in Open Files" })
vim.keymap.set("n", "<leader>fs", require("telescope.builtin").builtin, { desc = "[F]ind [S]elect Telescope" })
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").git_files, { desc = "[F]ind [G]it [F]iles" })
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fG", ":LiveGrepGitRoot<cr>", { desc = "[F]ind by [G]rep on Git Root" })
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fr", require("telescope.builtin").resume, { desc = "[F]ind [R]esume" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of "nvim {filename}"
vim.defer_fn(function()
  require("nvim-treesitter.configs").setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { "c", "cpp", "go", "lua", "python", "rust", "tsx", "javascript", "typescript", "vimdoc", "vim", "bash" },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,
    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- List of parsers to ignore installing
    ignore_install = {},
    -- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
    modules = {},
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        scope_incremental = "<c-s>",
        node_decremental = "<M-space>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
  }
end, 0)

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
  nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

-- document existing key chains
wk.add({
  { "<leader>c",  group = "[C]ode" },
  { "<leader>c_", hidden = true },
  { "<leader>d",  group = "[D]ocument" },
  { "<leader>d_", hidden = true },
  { "<leader>f",  group = "[F]ind" },
  { "<leader>f_", hidden = true },
  { "<leader>g",  group = "[G]it" },
  { "<leader>g_", hidden = true },
  { "<leader>h",  group = "Git [H]unk" },
  { "<leader>h_", hidden = true },
  { "<leader>t",  group = "[T]oggle" },
  { "<leader>t_", hidden = true },
  { "<leader>w",  group = "[W]orkspace" },
  { "<leader>w_", hidden = true },
})
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
wk.add({
  { "<leader>",  group = "VISUAL <leader>", mode = "v" },
  { "<leader>h", desc = "Git [H]unk",       mode = "v" },
})

wk.add({
  { "<leader>hs", group = "[S]tage [H]unk",   mode = "n", },
  { "<leader>hr", group = "[H]unk [R]eset",   mode = "n", },
  { "<leader>hS", group = "[S]tage Buffer",   mode = "n", },
  { "<leader>hR", group = "[R]eset Buffer",   mode = "n", },
  { "<leader>hp", group = "[P]review",        mode = "n", },
  { "<leader>hi", group = "Preview [I]nline", mode = "n", },
  { "<leader>hb", group = "[B]lame Line",     mode = "n", },
  { "<leader>hd", group = "[D]iff",           mode = "n", },
  { "<leader>hq", group = "setqflist",        mode = "n", },
  { "<leader>tb", group = "[B]lame",          mode = "n", },
  { "<leader>td", group = "[D]eleted",        mode = "n", },
  { "<leader>tW", group = "[W]ord Diff",      mode = "n", },
})

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.

local servers = {
  angularls = {},
  awk_ls = {},
  cssls = {},
  gopls = {},
  html = {},
  jqls = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS"s noisy `missing-fields` warnings
      -- diagnostics = { disable = { "missing-fields" } },
    },
  },
  pyright = {},
  ts_ls = {}
}

require("mason").setup()
local mason_lspconfig = require "mason-lspconfig"
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = true
}
require("mason-nvim-dap").setup({
  ensure_installed = { "python" },
  automatic_installation = true,
})

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '🔵', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '⭐️', texthl = '', linehl = '', numhl = '' })

local dap, dapui = require("dap"), require("dapui")
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      return "/usr/bin/python3.13"
    end,
  },
}
dapui.setup()
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
  require("neo-tree").close_all()
end
-- dap.listeners.before.event_thread.dapui_config = function ()
--   dapui.toggle()
-- end

vim.keymap.set("n", "<F5>", "<cmd>:wa<cr>:lua require'dap'.continue()<cr>", { desc = "Run" })
vim.keymap.set('n', '<F6>', function() require("dap").terminate() end, { desc = "Terminate" })
vim.keymap.set("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "Debug Toggle Breakpoint" })
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end, { desc = "Debug Step Over" })
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end, { desc = "Debug Step Into" })
-- vim.keymap.set("n", "<F12>", function() require("dap").step_out() end, { desc = "Debug Step Out" })

vim.keymap.set("n", "<Leader>dt", function() dapui.toggle() end, { desc = "[D]ebug [T]oggle" })
vim.keymap.set('n', '<leader>dk', ':lua require"dap".up()<CR>zz', { desc = "[D]ebug Up" })
vim.keymap.set('n', '<leader>dj', ':lua require"dap".down()<CR>zz', { desc = "[D]ebug Down" })

vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
  require("dap.ui.widgets").hover()
end, { desc = "[D]ebug [H]over" })

vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
  require("dap.ui.widgets").preview()
end, { desc = "[D]ebug [P]review" })

vim.keymap.set("n", "<Leader>df", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end, { desc = "[D]ebug [F]rames" })

vim.keymap.set("n", "<Leader>ds", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end, { desc = "[D]ebug [S]copes" })

vim.keymap.set("n", "<Leader>de", "<cmd>lua require('dapui').eval()<cr>", { desc = "[D]ebug [E]val" })

require("nvim-dap-virtual-text").setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property "filetypes" to the map in question.

local linters = {
  "debugpy", "prettier", "black", "delve", "jq", "markdownlint", "firefox-debug-adapter",
}
-- COMENTED until fix
-- https://github.com/rshkarin/mason-nvim-lint/issues/22

-- require('mason-nvim-lint').setup({
--   ensure_installed = linters,
--   automatic_installation = true,
--   ignore_install = { "inko", "ruby", "janet", "clj-kondo", "vale" },
--   quiet_mode = false
-- })

-- Setup neovim lua configuration
require("neodev").setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
  debug = true,
  setup_jsonls = true,
  override = function(root_dir, library)
    library.enabled = true
    library.plugins = true
  end,
  lspconfig = true,
  pathStrict = true,
})

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require "cmp"
local luasnip = require "luasnip"
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete {},
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
