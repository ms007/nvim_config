return {
  'mfussenegger/nvim-jdtls',
  ft = 'java',
  dependencies = {
    'mason-org/mason.nvim',
    'saghen/blink.cmp',
    'mfussenegger/nvim-dap',
  },
  config = function()
    local jdtls = require 'jdtls'

    -- Pfade zu Mason-installierten Tools
    local mason_path = vim.fn.stdpath 'data' .. '/mason/packages'
    local jdtls_path = mason_path .. '/jdtls'
    local launcher = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
    local config_dir = jdtls_path .. '/config_mac_arm'

    -- Debug-Bundles sammeln (java-debug-adapter + java-test)
    local bundles = {}
    local debug_jar = vim.fn.glob(mason_path .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar')
    if debug_jar ~= '' then
      table.insert(bundles, debug_jar)
    end
    local test_jars = vim.split(vim.fn.glob(mason_path .. '/java-test/extension/server/*.jar', true), '\n')
    for _, jar in ipairs(test_jars) do
      if jar ~= '' then
        table.insert(bundles, jar)
      end
    end

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local function start_jdtls()
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
        init_options = {
          bundles = bundles,
        },
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

          -- DAP nach LSP-Init registrieren
          jdtls.setup_dap { hotcodereplace = 'auto' }
          map('<leader>jt', require('jdtls').test_nearest_method, '[T]est Nearest Method')
          map('<leader>jT', require('jdtls').test_class, '[T]est Class')
        end,
      }
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = start_jdtls,
    })

    start_jdtls()
  end,
}
