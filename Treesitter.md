# Treesitter

Hinweise zu optionalen Erweiterungen der Treesitter-Konfiguration in
`lua/kickstart/plugins/treesitter.lua`.

Das Setup nutzt den `main`-Branch von `nvim-treesitter` (kompletter Rewrite,
kompatibel mit Neovim 0.12). Voraussetzung ist das systemweit installierte
`tree-sitter` CLI (`brew install tree-sitter-cli`), da Parser beim ersten
Öffnen einer Datei lokal kompiliert werden.

## Textobjects

Erlauben Selektion und Operationen auf semantischen Code-Einheiten
(Funktionen, Klassen, Argumenten, Blöcken). Beispiele:

- `daf` — delete around function (ganze Funktion löschen)
- `vic` — visually select inner class
- `yia` — yank inner argument

### Aktivieren

In `lua/kickstart/plugins/treesitter.lua` als zweiten Eintrag im
`return { ... }` Block ergänzen (neben dem bestehenden
`nvim-treesitter`-Eintrag):

```lua
{
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-treesitter-textobjects').setup {
      select = {
        lookahead = true,
      },
    }
    local select = require('nvim-treesitter-textobjects.select').select_textobject

    vim.keymap.set({ 'x', 'o' }, 'af', function() select '@function.outer' end, { desc = 'around function' })
    vim.keymap.set({ 'x', 'o' }, 'if', function() select '@function.inner' end, { desc = 'inner function' })
    vim.keymap.set({ 'x', 'o' }, 'ac', function() select '@class.outer' end, { desc = 'around class' })
    vim.keymap.set({ 'x', 'o' }, 'ic', function() select '@class.inner' end, { desc = 'inner class' })
    vim.keymap.set({ 'x', 'o' }, 'aa', function() select '@parameter.outer' end, { desc = 'around argument' })
    vim.keymap.set({ 'x', 'o' }, 'ia', function() select '@parameter.inner' end, { desc = 'inner argument' })
  end,
},
```

Nach dem Speichern: `:Lazy sync` ausführen, damit der `main`-Branch des
Plugins ausgecheckt wird.

### Übersicht Keymaps

| Keymap | Bedeutung                  |
| ------ | -------------------------- |
| `af`   | around function            |
| `if`   | inner function             |
| `ac`   | around class               |
| `ic`   | inner class                |
| `aa`   | around argument/parameter  |
| `ia`   | inner argument/parameter   |

Funktionieren in Visual-Mode (`v` davor) und als Operator (`d`, `y`, `c`
davor).

## Incremental Selection

Erweitert eine Selektion schrittweise entlang der Treesitter-Knoten — vom
Wort über Ausdruck bis zur ganzen Funktion.

### Aktivieren

Irgendwo nach dem `vim.treesitter.start(...)` Aufruf in der
`config`-Funktion oder in `lua/keymaps.lua` ergänzen:

```lua
vim.keymap.set('n', '<C-Space>', function()
  vim.cmd 'normal! v'
  require('nvim-treesitter.incremental_selection').node_incremental()
end, { desc = 'Start TS incremental selection' })

vim.keymap.set('x', '<C-Space>', function()
  require('nvim-treesitter.incremental_selection').node_incremental()
end, { desc = 'TS expand selection' })

vim.keymap.set('x', '<C-BS>', function()
  require('nvim-treesitter.incremental_selection').node_decremental()
end, { desc = 'TS shrink selection' })
```

Trigger bei Bedarf anpassen. `v`/`V` sind ungeeignet, da sie mit dem
normalen Vim-Visual-Mode kollidieren würden.
