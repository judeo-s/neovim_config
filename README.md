# Neovim config

> [!WARNING]
> Supports Neovim 0.11 + only

> [!SUMMARY]
> Trying to keep it as simple as possible:

---

# Lsp

- lspconfig with neovim 0.11+ `vim.lsp.config/enable` features
- found in `lua/plugins/lsp.lua`
- add lsp to where you see things like these and add yours
  ```lua
  vim.lsp.config('server-name',
    {
      capabilities = globalcapabilites
      -- other bad configs
    }
  )
  vim.lsp.enable('server-name')
  ```
- or do `:Mason`

- Diagnostics , important, there are 2 functions (this is also found in `lsp.lua`)

  ```lua
      -- this will make diagnostics show constantly
      function enable_diagnostics_default()

      -- this will make diagnostics on Keybinding
      function enable_toggle_diagnostics(keybinding)

      -- default
      enable_diagnostics_default()
  ```

---

# Cmp & snip

- i dunno, nvim.mini handles it

---

# others

- found in `lua/plugins/others.lua`

  | plugin            | function                   |
  | ----------------- | -------------------------- |
  | neotree           | minimal file tree          |
  | harpoon           | minimal file buffer editor |
  | presence          | discord flex               |
  | whichkey          | helps find keybindings     |
  | nvim window       | easy window move           |
  | vimtex            | latex                      |
  | lualine           | the bar at the bottom      |
  | markview          | render md                  |
  | indent blank line | the color indent           |
  | typr              | mavis becon                |

---

# install Dependencies

- only for Archlinux
  `chmod +x ./install.sh`
