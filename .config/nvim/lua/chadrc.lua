local M = {}

M.plugins = {
  ["nvim-telescope/telescope.nvim"] = {
    override_options = function()
      return {
        extensions = {
          recent_files = {
            only_cwd = true,
            show_current_file = true,
          }
        }
      }
    end,

  },
}

M.ui = {
	theme = "ayu_dark",
  tabufline = {
    enabled= false
  },
  statusline = {
    order = { "mode", "file", "git", "%=" },
    separator_style = "default",
  },
}

return M
