# Treesitter-Outer

> In Some language like C/CPP, Go, Rust..., I always use `[{` and `]}` to jump outer { and }. But in lua, python..., it's not work any more. So i write this plug to do this.

jump to outer node with smart way based on [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

## Default Configuration
``` lua
    require("treesitter-outer").setup {
        filetypes = { "c", "cpp", "elixir", "fennel", "foam", "go", "javascript", "julia", "lua", "nix", "php", "python",
            "r", "ruby", "rust", "scss", "tsx", "typescript" },
        -- set `[{` and `]}` to jump outer node
        defaultKey = true",
    }
```
