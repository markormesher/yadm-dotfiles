require("mormesher/globals")

--
-- LSP actions via lspsaga
--

local lsp_saga_ok, lsp_saga = check_plugin("lspsaga")
if (lsp_saga_ok) then
  lsp_saga.setup({
    symbol_in_winbar = {
      enable = false
    },
    lightbulb = {
      enable = false
    },
    rename = {
      quit = "<esc>",
      in_select = false,
    }
  })

  -- floating terminal
  keymap.set("n", "<c-space>", "<cmd>Lspsaga term_toggle<cr>")
  keymap.set("t", "<c-space>", "<cmd>Lspsaga term_toggle<cr>")

  -- show documentation snippet
  keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>")

  -- find definition and uses
  keymap.set("n", "<leader>f", "<cmd>Lspsaga lsp_finder<cr>")

  -- rename synbol
  keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<cr>")

  -- code actions
  keymap.set("n", "<leader> ", "<cmd>Lspsaga code_action<cr>")

  -- jump to next/prev issue
  keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<cr>")
  keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<cr>")
end

--
-- Vim diagnostic settings
--

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "LspDiagnosticsDefaultError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "LspDiagnosticsDefaultWarning" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "LspDiagnosticsDefaultInformation" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌶", texthl = "LspDiagnosticsDefaultHint" })
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = {
    enable = true,
    prefix = ""
  },
  update_in_insert = false,
  signs = true
})

--
-- Actual language servers
--

local lsp_ok, lsp = check_plugin("lspconfig")
local cmp_nvim_lsp_ok, cmp_nvim_lsp = check_plugin("cmp_nvim_lsp")
if (lsp_ok and cmp_nvim_lsp) then
  local cmp_capabilities = cmp_nvim_lsp.default_capabilities()

  -- eslint
  lsp.eslint.setup({
    capabilities = cmp_capabilities,
    on_attach = function()
      -- eslint doesn"t support autoFixOnSave, so run EslintFixAll instead
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("eslint_lsp", {}),
        pattern = { "*.tsx", "*.ts", "*.jsx", "*.js", },
        command = "EslintFixAll",
      })
    end,
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.tsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx"
    }
  })

  -- typescript
  lsp.tsserver.setup({
    -- TODO: imports not being shown from other files in the project
    capabilities = cmp_capabilities,
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.tsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx"
    },
    cmd = { "typescript-language-server", "--stdio" }
  })
end

--
-- Auto completion
--

local cmp_ok, cmp = check_plugin("cmp")
local luasnip_ok, luasnip = check_plugin("luasnip")

if (cmp_ok and luasnip_ok) then
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end
    },
    mapping = {
      ["<cr>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })
        else
          fallback()
        end
      end, { "i", "c" }),
      ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
      ["<up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "luasnip" },
    }
  })

  cmd("set completeopt=menuone,noinsert,noselect")
end
