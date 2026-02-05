return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    keymaps = {
      ['\\'] = 'actions.parent',
      ['<CR>'] = 'actions.select',
      ['g?'] = 'actions.show_help',
      ['gg'] = { 'actions.cd', mode = 'n' },
      ['<C-h>'] = false,
      ['<C-l>'] = false,
      ['<C-r>'] = 'actions.refresh',
      ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
      -- Additional actions can be found in the help file:
      -- :help oil-actions
    },
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      natural_order = true,
      is_always_hidden = function(name, _)
        return name == '..' or name == '.git'
      end,
    },
    win_options = {
      wrap = true,
    },
  },
  -- Optional dependencies

  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  config = function(_, opts)
    require('oil').setup(opts)

    -- Definiere ein globales Keybinding, um Oil zu öffnen.
    -- Dieses Keybinding ist in JEDEM Puffer aktiv (im Normalmodus 'n').
    -- Wir verwenden '\' (backslash), um das aktuelle Verzeichnis in Oil zu öffnen.
    vim.keymap.set('n', '\\', function()
      require('oil').open()
    end, { desc = 'Open Oil in current directory' })
  end,
}
