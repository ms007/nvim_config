local config = function()
  require("tokyonight").setup({
    on_highlights = function(hl, colors)
      hl.NvimTreeFolderIcon = {
        fg = "#FCC76A"
      }
    end
      
  })
	vim.cmd('colorscheme tokyonight-night')
end

return {
	"folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
	config = config
}


