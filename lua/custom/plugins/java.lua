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

    -- Java project run/restart state
    local java_run_buf = nil

    local function stop_java()
      if java_run_buf and vim.api.nvim_buf_is_valid(java_run_buf) then
        local chan = vim.b[java_run_buf].terminal_job_id
        if chan then
          vim.fn.jobstop(chan)
        end
        vim.api.nvim_buf_delete(java_run_buf, { force = true })
      end
      java_run_buf = nil
    end

    local function detect_run_cmd(root_dir)
      local has_mvnw = vim.fn.filereadable(root_dir .. '/mvnw') == 1
      local has_pom = vim.fn.filereadable(root_dir .. '/pom.xml') == 1
      local has_gradlew = vim.fn.filereadable(root_dir .. '/gradlew') == 1
      local has_gradle = vim.fn.filereadable(root_dir .. '/build.gradle') == 1
        or vim.fn.filereadable(root_dir .. '/build.gradle.kts') == 1

      if has_pom then
        local mvn = has_mvnw and './mvnw' or 'mvn'
        local pom = table.concat(vim.fn.readfile(root_dir .. '/pom.xml'), '\n')
        if pom:find 'spring%-boot' then
          return mvn .. ' spring-boot:run'
        end
        return mvn .. ' compile exec:java'
      elseif has_gradle then
        local gradle = has_gradlew and './gradlew' or 'gradle'
        local build_file = root_dir .. '/build.gradle'
        if vim.fn.filereadable(build_file) == 0 then
          build_file = root_dir .. '/build.gradle.kts'
        end
        local content = table.concat(vim.fn.readfile(build_file), '\n')
        if content:find 'spring' then
          return gradle .. ' bootRun'
        end
        return gradle .. ' run'
      end
      return nil
    end

    local function run_java(root_dir)
      stop_java()
      -- Ensure wrapper scripts are executable
      for _, wrapper in ipairs { 'gradlew', 'mvnw' } do
        local path = root_dir .. '/' .. wrapper
        if vim.fn.filereadable(path) == 1 and not vim.uv.fs_access(path, 'X') then
          vim.fn.system { 'chmod', '+x', path }
        end
      end
      local cmd = detect_run_cmd(root_dir)
      if not cmd then
        vim.notify('No Maven/Gradle project found', vim.log.levels.WARN)
        return
      end
      vim.cmd 'botright split | resize 15'
      vim.fn.termopen(cmd, { cwd = root_dir })
      java_run_buf = vim.api.nvim_get_current_buf()
      vim.cmd 'wincmd p'
      vim.notify('Running: ' .. cmd, vim.log.levels.INFO)
    end

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
          '--add-opens',
          'java.base/java.util=ALL-UNNAMED',
          '--add-opens',
          'java.base/java.lang=ALL-UNNAMED',
          '-jar',
          launcher,
          '-configuration',
          config_dir,
          '-data',
          workspace_dir,
        },
        root_dir = root or vim.fn.getcwd(),
        capabilities = capabilities,
        init_options = {
          bundles = bundles,
        },
        settings = {
          java = {
            format = {
              settings = {
                profile = {
                  tabSize = 4,
                  indentationSize = 4,
                },
              },
            },
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

          -- Run / Stop
          map('<leader>jr', function()
            run_java(root or vim.fn.getcwd())
          end, '[R]un / Restart Project')
          map('<leader>jS', stop_java, '[S]top Project')

          -- DAP nach LSP-Init registrieren
          jdtls.setup_dap { hotcodereplace = 'auto' }
          require('jdtls.dap').setup_dap_main_class_configs()
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
