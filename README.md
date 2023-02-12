# migemo-search.nvim

Integrate Neovim search with migemo.
Ported from [rhysd/migemo-search.nvim](https://github.com/rhysd/migemo-search.vim).

## Installation

### packer.nvim

```lua
use({ "sei40kr/migemo-search.nvim", event = "CmdlineEnter *" })
```

### lazy.nvim

```lua
require("lazy").setup({
  { "sei40kr/migemo-search.nvim", event = "CmdlineEnter" }
})
```

### Configuration

```lua
local ms = require("migemo-search")
ms.setup({
  cmigemo_exec_path = "/path/to/cmigemo",
  migemo_dict_path = "/path/to/migemo-dict",
})
vim.keymap.set("c", "<CR>", ms.cr)
```

### Credits

- [rhysd/migemo-search.vim](https://github.com/rhysd/migemo-search.vim)
