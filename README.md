# Treesitter-Outer

> In Some language like C/CPP, Go, Rust..., I always use `[{` and `]}` to jump outer { and }. But in lua, python..., it's not work any more. So i write this plug to do this.

jump to outer node smartly base on [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) And thank [nvim-treesitter-text-subject](https://github.com/RRethy/nvim-treesitter-textsubjects) to provide Tree-Sitter queries

## Installation

With [lazy.nvim](https://github.com/folk/lazy.nvim):

``` lua
    {
        'Mr-LLLLL/treesitter-outer',
        dependencies = "nvim-treesitter/nvim-treesitter",
        -- only load this plug in follow filetypes
        ft = {
            "c",
            "cpp",
            "elixir",
            "fennel",
            "foam",
            "go",
            "javascript",
            "julia",
            "lua",
            "nix",
            "php",
            "python",
            "r",
            "ruby",
            "rust",
            "scss",
            "tsx",
            "typescript",
        },
        -- default config
        opts = {
            filetypes = {
                "c",
                "cpp",
                "elixir",
                "fennel",
                "foam",
                "go",
                "javascript",
                "julia",
                "lua",
                "nix",
                "php",
                "python",
                "r",
                "ruby",
                "rust",
                "scss",
                "tsx",
                "typescript",
            },
            mode = { 'n', 'v' },
            prev_outer_key = "[{",
            next_outer_key = "]}",
        },
    }
```
