return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree toggle" },
  },
  config = function()
    require("nvim-tree").setup({
      actions = {
        open_file = {
          quit_on_open = true
        }
      },
      view = {
        side = "right"
      },
    })
  end
}
