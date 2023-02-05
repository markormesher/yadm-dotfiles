require("mormesher/globals")

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
    cmd("packadd packer.nvim")
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  --
  -- language integration
  --

  -- tree-sitter abstraction layer
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        ensure_installed = {
          "css",
          "help",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "scss",
          "typescript",
          "vim",
          "yaml",
        },
        highlight = {
          enabled = true
        },
        indent = {
          enabled = true
        }
      })
    end
  })

  -- language server
  use("neovim/nvim-lspconfig")
  use("jose-elias-alvarez/null-ls.nvim")
  use("glepnir/lspsaga.nvim")

  -- autocompletion
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      -- snippet engine
      { "L3MON4D3/LuaSnip" },

      -- completion sources
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
    }
  });

  --
  -- UI
  --

  -- colourscheme
  use({
    "dracula/vim",
    config = function()
      cmd("colorscheme dracula")
    end
  })

  -- status line
  use({
    "nvim-lualine/lualine.nvim",
    requires = {
      { "nvim-tree/nvim-web-devicons" }
    },
    config = function()
      require("lualine").setup()
    end
  })

  -- show marks in the gutter
  use("kshenoy/vim-signature")

  --
  -- general typing tools
  --

  -- gcc to (un)comment a line, gc to (un)comment a visual selection
  use("tpope/vim-commentary")

  -- detect indentation style and adjust settings
  use("tpope/vim-sleuth")

  -- highlight trailing spaces and provides :StripWhitespace helper
  use({
    "ntpeters/vim-better-whitespace",
    config = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        command = ":StripWhitespace"
      })
    end
  })

  -- highlight good options for navigation within a line
  use({
    "unblevable/quick-scope",
    config = function()
      -- TODO: this doesn't seem to work
      vim.api.nvim_set_hl(0, "QuickScopePrimary", { underline = true })
      vim.api.nvim_set_hl(0, "QuickScopeSecondary", { underline = true, italic = true })
    end
  })

  --
  -- tools
  --

  -- file browser
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      { "nvim-tree/nvim-web-devicons" }
    },
    config = function()
      require("nvim-tree").setup({
        git = {
          enable = true,
        },
        actions = {
          open_file = {
            quit_on_open = true
          }
        }
      })

      local tree_api = require("nvim-tree.api");
      keymap.set("n", "<leader>m", function() tree_api.tree.toggle({ update_root = true }) end)
      keymap.set("n", "<leader>n", function() tree_api.tree.toggle({ update_root = true, find_file = true }) end)
    end,
  })

  -- fuzzy search
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      {
        "nvim-lua/plenary.nvim"
      }
    },
    config = function()
      -- TODO: gitignore is not ignored
      local telescope = require("telescope")
      local telescope_actions = require("telescope.actions")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = telescope_actions.close
            }
          }
        },
        pickers = {
          find_files = {
            hidden = true
          },
          live_grep = {
            hidden = true
          }
        }
      })

      local builtin_pickers = require("telescope.builtin")
      keymap.set("n", "<leader>,", builtin_pickers.find_files)
      keymap.set("n", "<leader>.", builtin_pickers.live_grep)
    end,
  })

  --
  -- package management (keep at the bottom)
  --

  -- automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require("packer").sync()
  end
end)
