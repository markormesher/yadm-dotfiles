require("mormesher/globals")

-- local cmp_ok, cmp = pcall(require, "cmp")
-- if (lsp_ok) then
--   cmp.setup({
--     snippet = {
--       expand = function(args)
--         require("luasnip").lsp_expand(args.body)
--       end
--     },
--     sources = {
--       { name = "buffer" },
--       { name = "nvim_lsp" },
--       { name = "luasnip" },
--     }
--   })
--   cmd("set completeopt=menuone,noinsert,noselect")
-- end


--
-- LSP actions via lspsaga
--

local lsp_saga_ok, lsp_saga = pcall(require, "lspsaga")
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
-- Actual language servers
--

local lsp_ok, lsp = pcall(require, "lspconfig")
if (lsp_ok) then

  vim.diagnostic.config({
    update_in_insert = true,
    signs = true
  })

  -- eslint
  lsp.eslint.setup({
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
