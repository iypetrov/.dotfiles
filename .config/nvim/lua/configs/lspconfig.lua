local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"
local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set("i", "<C-p>", function() cmp.mapping.select_prev_item(cmp_select) end, opts)
        vim.keymap.set("i", "<C-n>", function() cmp.mapping.select_next_item(cmp_select) end, opts)

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "rr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "rn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)

        vim.keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

        -- Go
        vim.keymap.set("n", "<leader>ge", "<cmd>GoIfErr<CR>", opts)
        vim.keymap.set("n", "<leader>gc", "<cmd>GoIfCmt<CR>", opts)
        vim.keymap.set("n", "<leader>gt", "<cmd>GoTestAdd<CR>", opts)
        vim.keymap.set("n", "<leader>ga", "<cmd>GoTestsAll<CR>", opts)
        vim.keymap.set("n", "<leader>gj", "<cmd>GoTagAdd json<CR>", opts)
    end
})

lspconfig.gopls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

lspconfig.tsserver.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_dir = util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
  init_options = {
    preferences= {
      disableSuggestions = true,
    }
  },
}

lspconfig.dockerls.setup{
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "docker-langserver", "--stdio" },
  filetypes = {"dockerfile"},
  root_dir = util.root_pattern("Dockerfile"),
  single_file_support = true,
}

lspconfig.terraform_lsp.setup{
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "terraform-lsp" },
  filetypes = {"terraform", "hcl"},
  root_dir = util.root_pattern(".terraform", ".git"),
  single_file_support = true,
}

lspconfig.jsonls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true
  },
  root_dir = util.find_git_ancestor(),
  single_file_support = true,
}

lspconfig.yamlls.setup{
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yam;.gitlab" },
  root_dir = util.find_git_ancestor(),
  single_file_support = true,
  settings = {
    {
      schemas = {
        kubernetes = "*.yaml",
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
        ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
        ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
        ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
        ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
        ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
      },
    }
  },
}

lspconfig.bashls.setup{
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "bash-language-server", "start" },
  root_dir = util.find_git_ancestor,
  single_file_support = true,
  settings = {
    {
      bashIde = {
        globPattern = "*@(.sh|.inc|.bash|.command)"
      }
    }
  },
}
