return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  keys = {
    { "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "NvimTree toggle" },
  },
  config = function()
    require("nvim-tree").setup({
      actions = {
        open_file = {
          quit_on_open = true
        }
      },
      filters = {
        dotfiles = false,
        git_clean = false,
        custom = { "node_modules", ".git" },
      },
      view = {
        adaptive_size = true,
        side = "right"
      },
      git = {
        enable = true,
        ignore = true,
      },
      renderer = {
        highlight_git = true,
        highlight_opened_files = "none",
        root_folder_modifier = ":t",
        icons = {
          git_placement = "after",
          glyphs = {
            folder = {
              default = "",
              open = "",
            }
          },
        }
      }
    })
  end
}
