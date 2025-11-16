return {
  cmd = {'typescript-language-server', '--stdio'},
  filetypes = {'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx'},
  root_markers = {'tsconfig.json', 'package.json'},
  init_options = {
    preferences= {
      disableSuggestions = true,
    }
  },
}
