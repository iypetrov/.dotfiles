-- mappings
vim.scriptencoding = 'utf-8'
vim.o.encoding = 'utf-8'
vim.g.mapleader = ' '
vim.o.background = "light"
local ok, _ = pcall(vim.cmd, "colorscheme gruvbox")
if not ok then
  vim.cmd("colorscheme default")
end
vim.o.autoread = true
vim.o.backspace = 'indent,eol,start'
vim.o.colorcolumn = '80'
vim.o.hidden = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.ruler = true
vim.o.scrolloff = 999
vim.o.showmatch = true
vim.o.showmode = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.title = true
vim.o.visualbell = true
vim.o.wrap = false
vim.o.sessionoptions = "curdir,folds,help,options,tabpages,winsize"
vim.cmd("syntax on")
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = vim.fn.expand("~/.vim/undodir")
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.smartcase = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.wildmode = "list:longest"
vim.opt.wildignore:append({".git",".hg",".svn","*.6","*.pyc","*.rbc","*.swp"})
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', '<leader>s', ':split<CR>', { silent = true })
vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+Y')
vim.keymap.set('v', '<leader>Y', '"+Y')
vim.keymap.set('n', '<leader>p', '"_dP')
vim.keymap.set('v', '<leader>p', '"_dP')
vim.keymap.set('v', '<leader>d', '"_d')
vim.keymap.set('n', '<leader>pv', ':Ex<CR>')
vim.keymap.set('n', '<leader>r', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>')
vim.keymap.set('n', '<leader>/', ':nohlsearch<CR>', { silent = true })
vim.cmd([[cnoremap w!! %!sudo tee > /dev/null %]])
vim.keymap.set('n', '<leader>d', ':bd<CR>', { silent = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    command = "set foldlevel=999999"
})
vim.diagnostic.config({
    virtual_text = {
        prefix = "D",
        spacing = 2,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
})

-- packages
local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
  if not (vim.uv or vim.loop).fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end
  vim.opt.rtp:prepend(pckr_path)
end
bootstrap_pckr()

require('pckr').add{
  'morhetz/gruvbox',

  {
    'airblade/vim-gitgutter',
    config = function()
      vim.g.gitgutter_sign_added = '+'
      vim.g.gitgutter_sign_modified = '~'
      vim.g.gitgutter_sign_removed = '-'
    end
  },

  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set('n', '<leader>h', ':UndotreeToggle<CR>', { noremap = true, silent = true })
    end
  },

  'github/copilot.vim',

  'nvim-lua/plenary.nvim';
  {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          prompt_prefix = "🔍 ",
          file_ignore_patterns = { "node_modules", "%.git/" },
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--ignore", "--hidden", "--files" },
          },
        },
        extensions = {
          recent_files = {
            only_cwd = true,
            show_current_file = false,
          },
        },
      })

      pcall(function()
        telescope.load_extension("recent_files")
      end)

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
      vim.keymap.set('n', '<leader>fp', builtin.live_grep, {})
    end,
  },
  { 'iypetrov/harpoon',
    branch = 'override-list-prev-next',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
      vim.keymap.set("n", "<leader><leader>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)
      vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
    end,
  },

  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
        require("lsp_lines").setup()
        vim.diagnostic.config({ virtual_text = false })
    end
  },

  'neovim/nvim-lspconfig';
  'hrsh7th/nvim-cmp';
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-buffer';
  'hrsh7th/cmp-path';
  'hrsh7th/cmp-cmdline';
  'L3MON4D3/LuaSnip';
  'saadparwaiz1/cmp_luasnip';

  'fatih/vim-go';
}

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "gs", function() vim.lsp.buf.signature_help() end, opts)

        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "rr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "rn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)

        vim.keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "qf" },
--   callback = function()
--     vim.keymap.set("n", "<CR>", function()
--       local win = vim.api.nvim_get_current_win()
--       vim.cmd("copen")
--       vim.cmd("cc")
--       vim.api.nvim_win_close(win, true)
--     end, { buffer = true })
--   end,
-- })

local cmp = require('cmp')
local luasnip = require('luasnip')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<Down>'] = cmp.mapping.select_next_item(cmp_select),
        ['<Up>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
})

vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    source = "if_many", -- show source if multiple LSPs
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- vim.g.go_def_mapping_enabled = 0
vim.g.go_fmt_command = "goimports"
vim.g.go_fmt_autosave = 0
vim.g.go_play_browser_command = "sudo -u ipetrov xdg-open %URL% &"
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.keymap.set("n", "<leader>err", "<cmd>GoIfErr<CR>", { buffer = true })
        vim.keymap.set("n", "<leader>dc", "<cmd>GoDocBrowser<CR>", { buffer = true })
    end,
})

local terraform_doc_browser = require("terraform_doc_browser")
terraform_doc_browser.setup()

local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.enable('terraformls', { capabilities = capabilities })
vim.lsp.enable('gopls', { capabilities = capabilities })
vim.lsp.enable('tsserver', { capabilities = capabilities })
vim.lsp.enable('luals', { capabilities = capabilities })
