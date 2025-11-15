-- basic
vim.scriptencoding = 'utf-8'
vim.o.encoding = 'utf-8'
vim.g.mapleader = ' '
vim.o.background = "light"
vim.cmd("colorscheme gruvbox")
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

-- custom
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

local cmd = require('pckr.loader.cmd')
local keys = require('pckr.loader.keys')
require('pckr').add{
  'morhetz/gruvbox';
  {
    'preservim/nerdtree',
    config = function()
      vim.g.NERDTreeShowHidden = 1
      vim.g.NERDTreeHijackNetrw = 0
      vim.keymap.set('n', '<C-t>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
    end
  },
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
  'nvim-treesitter/nvim-treesitter',
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
  'nvim-tree/nvim-web-devicons';
  {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons" },
  },
}

require('lualine').setup {
  options = { theme  = 'gruvbox' },
}
