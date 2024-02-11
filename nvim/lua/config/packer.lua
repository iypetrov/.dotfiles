vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
  use {
      'nvim-telescope/telescope.nvim', tag = '0.1.5',
      -- or                            , branch = '0.1.x',
      requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({
      'yonlu/omni.vim',
      as = 'omni',
      config = function()
          vim.cmd('colorscheme omni')

      end
  })

  use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"})

end)
