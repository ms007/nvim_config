local config = function()
  require("tokyonight").setup({
    on_highlights = function(hl, colors)
      hl.NvimTreeFolderIcon = {
        fg = "#FCC76A"
      }
      hl.NvimTreeFolderName = {
        fg = "#787c99"
      }
      hl.NvimTreeOpenedFolderName = {
        fg = "#787c99"
      }
      hl.NvimTreeGitDirty = {
        fg = "#6f92de"
      }
      hl.NvimTreeGitNew = {
        fg = "#449dab"
      }
      hl.NvimTreeNormal = {
        fg = "#787c99"
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

--[[ NvimTreeFolderIcon = 'fg'
NvimTreeIndentMarker = 'light_gray'
NvimTreeNormal = 'fg alt_bg'
NvimTreeVertSplit = 'alt_bg alt_bg'
NvimTreeFolderName = 'fg'
NvimTreeOpenedFolderName = 'fg - bi'
NvimTreeEmptyFolderName = 'gray - i'
NvimTreeGitIgnored = 'gray - i'
NvimTreeImageFile = 'light_gray'
NvimTreeSpecialFile = 'orange'
NvimTreeEndOfBuffer = 'alt_bg'
NvimTreeCursorLine = '- dark_gray'
NvimTreeGitStaged = 'sign_add_alt'
NvimTreeGitNew = 'sign_add_alt'
NvimTreeGitRenamed = 'sign_add_alt'
NvimTreeGitDeleted = 'sign_delete'
NvimTreeGitMerge = 'sign_change_alt'
NvimTreeGitDirty = 'sign_change_alt'
NvimTreeSymlink = 'cyan'
NvimTreeRootFolder = 'fg - b'
NvimTreeExecFile = '#9FBA89' ]]
