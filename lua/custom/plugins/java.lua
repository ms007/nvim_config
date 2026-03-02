return {
  'mfussenegger/nvim-jdtls',
  ft = 'java',
  dependencies = {
    'mason-org/mason.nvim',
    'saghen/blink.cmp',
  },
  config = function()
    local jdtls = require 'jdtls'

    -- Pfade zu Mason-installierten Tools
    local jdtls_path = vim.fn.stdpath 'data' .. '/mason/packages/jdtls'
    local launcher = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
    local config_dir = jdtls_path .. '/config_mac_arm'

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local function start_jdtls()
      -- Workspace pro Projekt (root_dir muss pro Buffer berechnet werden)
      local root = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
      local project_name = root and vim.fn.fnamemodify(root, ':t') or 'standalone'
      local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. project_name

      jdtls.start_or_attach {
        cmd = {
          'java',
          '-Declipse.application=org.eclipse.jdt.ls.core.id1',
          '-Dosgi.bundles.defaultStartLevel=4',
          '-Declipse.product=org.eclipse.jdt.ls.core.product',
          '-Dlog.protocol=true',
          '-Dlog.level=ALL',
          '-Xmx1g',
          '--add-modules=ALL-SYSTEM',
          '--add-opens', 'java.base/java.util=ALL-UNNAMED',
          '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
          '-jar', launcher,
          '-configuration', config_dir,
          '-data', workspace_dir,
        },
        root_dir = root or vim.fn.getcwd(),
        capabilities = capabilities,
        settings = {
          java = {
            signatureHelp = { enabled = true },
            completion = {
              favoriteStaticMembers = {
                'org.junit.Assert.*',
                'org.junit.Assume.*',
                'org.junit.jupiter.api.Assertions.*',
                'org.mockito.Mockito.*',
                'org.mockito.ArgumentMatchers.*',
              },
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
          },
        },
        on_attach = function(_, bufnr)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'Java: ' .. desc })
          end
          map('<leader>jo', jdtls.organize_imports, '[O]rganize Imports')
          map('<leader>jv', jdtls.extract_variable, 'Extract [V]ariable')
          map('<leader>jc', jdtls.extract_constant, 'Extract [C]onstant')
          vim.keymap.set('v', '<leader>jm', function()
            jdtls.extract_method(true)
          end, { buffer = bufnr, desc = 'Java: Extract [M]ethod' })
        end,
      }
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = start_jdtls,
    })

    -- Sofort starten, da ft=java das Plugin erst beim Öffnen einer .java-Datei lädt
    start_jdtls()
  end,
}
