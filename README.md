# 🍩 Donutlify.nvim

**Donutlify** is a fun Neovim plugin that transforms your buffer text into the
shape of a donut! The usage is the same as `center` command (see `:h
:center`).

The plugin creates as many donuts as possible with the given diameter and
crafts a smaller donut from any remaining text. Bring some sweetness to your
coding with Donutlify! 🍩

## ❓How to use

`:[range]Donutlify [diameter]`
Combine lines in `[range]` in the shape of the donut with `[diameter]`
characters in diameter (by default `'textwidth'` or 80 when `'textwidth'` is 0).
If there aren't enough characters to create a donut of the preferred diameter,
create the donut with the largest possible diameter.
If `[range]` is not specified, format the entire buffer.

## 📺 Showcase

<https://github.com/user-attachments/assets/7befd795-1d40-4b1c-bf77-59453dd70dba>

## 📋 Installation

[lazy](https://github.com/folke/lazy.nvim):

```lua
{
    "NStefan002/donutlify.nvim",
    lazy = false,
    version = "*",
}
```

[packer](https://github.com/wbthomason/packer.nvim):

```lua
use({ "NStefan002/donutlify.nvim", tag = "*" })
```

[rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim)

`:Rocks install donutlify.nvim`

> [!NOTE]
>
> - There is no need to call the `setup` function, only call it if you
>         need to change some options
> - There is no need to lazy load `donutlify`, it lazy loads by default.

## 👀 See also

- [web version of this plugin](https://nstefan002.github.io/donutlify/)
- [spinning donut screensaver](https://github.com/NStefan002/donut.nvim)
