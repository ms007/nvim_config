return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'javascript',
        'typescript',
        'tsx',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      textobjects = {
        select = {
          ['aa'] = '@parameter.outer', -- Around any parameter or argument
          ['ia'] = '@parameter.inner', -- Inner any parameter or argument
          ['af'] = '@function.outer', -- Around a function definition or call
          ['if'] = '@function.inner', -- Inner a function definition or call
          ['ac'] = '@class.outer', -- Around a class definition
          ['ic'] = '@class.inner', -- Inner a class definition
          ['ab'] = '@block.outer', -- Around a generic code block (often {})
          ['ib'] = '@block.inner', -- Inner a generic code block
          ['at'] = '@markup.outer', -- Around a markup tag (HTML/JSX)
          ['it'] = '@markup.inner', -- Inner a markup tag (HTML/JSX)
        },
      },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      -- Hier aktivierst du nvim-ts-autotag
      require('nvim-treesitter.configs').setup {
        autotag = {
          enable = true,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
