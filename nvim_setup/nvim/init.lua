-- ~/.config/nvim/init.lua

-- ==========================================
-- 1. Basic Neovim Settings
-- ==========================================
-- Set the leader key to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true

-- ==========================================
-- 2. Bootstrap Plugin Manager (lazy.nvim)
-- ==========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================
-- 3. Install and Configure Plugins
-- ==========================================
require("lazy").setup({
    -- Tree-sitter: Better syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- Added "python" to ensure_installed
                ensure_installed = { "c", "cpp", "rust", "python", "lua", "vim", "vimdoc" },
                highlight = { enable = true },
            })
        end
    },

    -- One Dark Theme
    {
        "navarasu/onedark.nvim",
        priority = 1000,                                 -- Load this before other plugins
        config = function()
            require('onedark').setup({ style = 'dark' }) -- options: 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer'
            vim.cmd("colorscheme onedark")
        end
    },

    -- Autocompletion UI
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- Connects the UI to Neovim's LSPs
            "L3MON4D3/LuaSnip",     -- Snippet engine (required by nvim-cmp to work)
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),            -- Manually trigger completion
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Enter to accept suggestion
                    ['<Tab>'] = cmp.mapping.select_next_item(),        -- Tab to go down
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(),      -- Shift+Tab to go up
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' }, -- Pull suggestions from LSPs (like Pyright)
                })
            })
        end
    },

    -- Mason: Package manager for LSPs, formatters, and linters
    {
        "mason-org/mason.nvim",
        dependencies = {
            "mason-org/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig", -- Mason still uses this for default LSP configurations
        },
        config = function()
            require("mason").setup()

            require("mason-lspconfig").setup({
                -- This tells Mason to automatically install rust-analyzer if it's missing
                ensure_installed = { "rust_analyzer" },
            })
        end
    },
    -- Formatting (conform.nvim)
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                -- Map filetypes to the formatters you want to use
                formatters_by_ft = {
                    python = { "isort", "black" }, -- isort organizes imports, black formats code
                    rust = { "rustfmt" },
                },
                -- Automatically format when you save a file
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true, -- If a specific formatter isn't found, try asking the LSP
                },
            })

            -- Create a keyboard shortcut (<Space> + f) to trigger formatting manually
            vim.keymap.set({ "n", "v" }, "<leader>f", function()
                require("conform").format({ lsp_fallback = true, timeout_ms = 500 })
            end, { desc = "Format file or range (Conform)" })
        end
    },

    -- Linting (nvim-lint)
    {
        "mfussenegger/nvim-lint",
        config = function()
            local lint = require("lint")

            -- Map filetypes to the linters you want to use
            lint.linters_by_ft = {
                python = { "flake8" },
                cpp = { "cpplint" },
                -- Note: Rust doesn't need a separate linter here because the rust-analyzer LSP
                -- handles deep linting and error checking natively.
            }

            -- Create an autocommand that runs the linter automatically
            -- "BufWritePost" = after saving
            -- "InsertLeave" = after you exit insert mode
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = vim.api.nvim_create_augroup("lint", { clear = true }),
                callback = function()
                    lint.try_lint()
                end,
            })
        end
    },
    -- File Explorer (nvim-tree)
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- Disable Neovim's built-in, clunky file explorer (netrw)
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            require("nvim-tree").setup({
                view = {
                    width = 30, -- Width of the sidebar
                    side = "left",
                },
            })

            -- Map <leader>e to toggle the file tree open and closed
            vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
        end
    },
    -- File Tabs (bufferline.nvim)
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            -- Enable true colors for the tabs to match your One Dark theme
            vim.opt.termguicolors = true

            require("bufferline").setup({
                options = {
                    -- Make it look like traditional IDE tabs
                    separator_style = "slant",
                    diagnostics = "nvim_lsp", -- Show LSP errors directly on the tabs
                }
            })

            -- Use Tab and Shift+Tab to cycle through your open files
            vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next File Tab" })
            vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Previous File Tab" })
        end
    },
    -- Keybinding Cheat Sheet (which-key.nvim)
    {
        "folke/which-key.nvim",
        event = "VeryLazy", -- Loads the plugin in the background so it doesn't slow down startup
        config = function()
            -- Neovim needs to know how long to wait before popping up the menu
            vim.o.timeout = true
            vim.o.timeoutlen = 300 -- Wait 300 milliseconds after a keypress before showing the menu

            require("which-key").setup({
                -- You can leave this completely empty to use the excellent defaults
            })
        end
    },
    -- Fuzzy Finder & Command Palette (telescope.nvim)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            local builtin = require('telescope.builtin')

            -- File and Text Search
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep (Search Text)" })

            -- The "I Forgot" Shortcuts
            vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = "Find Commands" })
            vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = "Find Keymaps" })
        end
    },
})

-- ==========================================
-- 4. Language Server Protocol (LSP) Setup
-- ==========================================
-- We need to tell the LSPs that we now have an autocompletion UI capable of handling their advanced features.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Python (Pyright)
vim.lsp.config('pyright', { capabilities = capabilities })
vim.lsp.enable('pyright')

-- C/C++ (clangd)
vim.lsp.config('clangd', {
    capabilities = capabilities,
    -- Disable formatting from the LSP so conform.nvim takes over completely
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
})
vim.lsp.enable('clangd')

-- Rust (rust-analyzer)
vim.lsp.config('rust_analyzer', { capabilities = capabilities })
vim.lsp.enable('rust_analyzer')
