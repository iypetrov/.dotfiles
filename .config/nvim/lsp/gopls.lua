return {
  cmd = {'gopls'},
  filetypes = {'go'},
  root_markers = {'go.mod', 'go.sum'},
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
