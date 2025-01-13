-- Core settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- lazy.nvim setup
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")

require("lazy").setup({
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig", -- Collection of LSP configurations
        dependencies = {
            { "williamboman/mason.nvim", config = true }, -- LSP Installer
            "williamboman/mason-lspconfig.nvim", -- Bridges Mason with LSPConfig
        },
        config = function()
            -- Setup Mason for managing LSP servers
            require("mason").setup()

            -- Setup Mason-LSPConfig
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "ts_ls",      -- TypeScript, JavaScript, JSX, TSX
                    "html",       -- HTML
                    "jsonls",     -- JSON
                    "pyright",    -- Python
                },
            })

            local lspconfig = require("lspconfig")

            -- TypeScript/JavaScript LSP
            lspconfig.ts_ls.setup({
                on_attach = function(_, bufnr)
                    local opts = { noremap = true, silent = true, buffer = bufnr }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                end,
                capabilities = require("cmp_nvim_lsp").default_capabilities(), -- Enable auto-completion
            })
        end,
    },

    -- Papercolor theme
    {
        "NLKNguyen/papercolor-theme",
        lazy = false,
        priority = 1000,
        config = function()
            vim.opt.background = "dark"
            vim.cmd("colorscheme PaperColor")
        end,
    },

    -- Gitsigns
    {
        "lewis6991/gitsigns.nvim",
        lazy = false, -- Load on startup
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "+" },
                    change       = { text = "~" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                },
                signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
                numhl      = true, -- Highlight line numbers
                linehl     = false, -- Highlight the line itself
                current_line_blame = true, -- Show blame info for the current line
            })
        end,
    },

    -- NERDTree
    {
        "preservim/nerdtree",
        lazy = true,
        cmd = { "NERDTreeToggle", "NERDTreeFind" },
        config = function()
            vim.g.NERDTreeShowLineNumbers = 1
            vim.g.NERDTreeGitStatusIndicatorMapCustom = {
                Modified  = "✚",
                Staged    = "✹",
                Untracked = "✭",
                Renamed   = "➜",
                Unmerged  = "═",
                Deleted   = "✖",
                Dirty     = "✗",
                Ignored   = "☒",
                Clean     = "✔︎",
                Unknown   = "?"
            }
            vim.cmd([[
                autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
            ]])
        end,
    },

    -- NERDTree Git plugin
    {
        "Xuyuanp/nerdtree-git-plugin",
        lazy = true,
        dependencies = { "preservim/nerdtree" },
    },

    -- nvim-treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false, -- Load on startup
        build = ":TSUpdate", -- Automatically install/update language parsers
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { 
                    "javascript", -- JavaScript
                    "typescript", -- TypeScript
                    "tsx", -- TypeScript with JSX (React)
                    "json", -- JSON
                    "html", -- HTML
                    "css", -- CSS
                    "lua" -- Lua (for configuring Neovim itself)
                },
                highlight = {
                    enable = true, -- Enable syntax highlighting
                },
                indent = {
                    enable = true, -- Optional: Enable Tree-sitter-based indentation
                },
            })

	-- Make `{}` more visible
        vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#ff00c8", bold = true }) -- Bright orange and bold
        end,
    },
    -- Auto-completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", max_item_count = 5 },
                    { name = "buffer", max_item_count = 3 },
                    { name = "path", max_item_count = 3 },
                }),
            })
        end,
    },

    -- GitHub Copilot
    {
	"github/copilot.vim",
	lazy = false, -- Load Copilot on startup
    },
})

-- Key mapping for NERDTree
vim.keymap.set("n", "<C-n>", ":NERDTreeToggle<CR>", { noremap = true, silent = true })


