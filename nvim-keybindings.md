# Neovim Keybindings

**Leader key:** `<Space>`

---

## Core (`keymaps.lua`)

### Insert Mode
| Mode | Key | Action |
|------|-----|--------|
| i | `jk` | Exit insert mode |
| i | `fd` | Exit insert mode |

### Editor
| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>nh` | Clear search highlights |
| n | `x` | Delete char without yanking |
| n | `<leader>+` | Increment number |
| n | `<leader>-` | Decrement number |
| n | `<CR>` | Toggle fold (filetype-aware) |
| x | `p` | Paste without yanking selection |
| n | `<leader>os` | Source current nvim config file |
| n | `<leader>oo` | Open file with default application |

### Save
| Mode | Key | Action |
|------|-----|--------|
| i, v, n | `<C-s>` | Save file and session |

### Indentation
| Mode | Key | Action |
|------|-----|--------|
| n | `<Tab>` | Indent line |
| n | `<S-Tab>` | Unindent line |
| v | `<Tab>` | Indent and reselect |
| v | `<S-Tab>` | Unindent and reselect |

### Buffer Management
| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>ba` | Select all buffer content |
| n | `<leader>bv` | Split buffer vertically |
| n | `<leader>bc` | Split buffer horizontally |
| n | `<leader>bu` | Reopen most recently closed buffer |

---

## LSP (`lsp.lua`)

| Mode | Key | Action |
|------|-----|--------|
| n | `gR` | Show LSP references (Telescope) |
| n | `gD` | Go to declaration |
| n | `gd` | Go to definition |
| n | `gi` | Show implementations (Telescope) |
| n | `gt` | Show type definitions (Telescope) |
| n, v | `<leader>ca` | Code actions |
| n | `<leader>rn` | Smart rename |
| n | `<leader>D` | Show buffer diagnostics (Telescope) |
| n | `<leader>d` | Show line diagnostics |
| n | `[d` | Go to previous diagnostic |
| n | `]d` | Go to next diagnostic |
| n | `K` | Show hover documentation |
| n | `<leader>rs` | Restart LSP |

---

## File Explorer & Telescope (`file-explorer.lua`)

### Oil.nvim
| Mode | Key | Action |
|------|-----|--------|
| n | `-` | Toggle Oil floating file explorer |

**Within Oil:**
| Key | Action |
|-----|--------|
| `<CR>` / `<2-LeftMouse>` | Select entry |
| `<C-v>` | Open in vertical split |
| `<C-h>` | Open in horizontal split |
| `<C-t>` | Open in new tab |
| `<C-p>` | Preview |
| `<C-c>` / `q` | Close/quit |
| `<C-l>` | Refresh |
| `-` | Parent directory |
| `_` | Open cwd |
| `` ` `` | Change directory |
| `~` | tcd to current directory |
| `gs` | Change sort |
| `gx` | Open external |
| `g.` | Toggle hidden |
| `g\` | Toggle trash |
| `<leader>?` | Show help |

### Telescope
| Mode | Key | Action |
|------|-----|--------|
| n | `<C-p>` | Find files in cwd |
| n | `<leader>ff` | Find files in cwd |
| n | `<leader>fr` | Recent files |
| n | `<leader>fs` | Live grep in cwd |
| n | `<leader>fc` | Grep string under cursor |
| n | `<leader>fb` | Find open buffers |
| n | `<leader>fh` | Find help tags |
| n | `<leader>fg` | Find changed git files |
| n | `<leader>ft` | Find todos |
| n | `<leader>fn` | Noice message history |

**Telescope internal:**
| Mode | Key | Action |
|------|-----|--------|
| i | `<C-k>` | Move selection up |
| i | `<C-j>` | Move selection down |
| i | `<C-q>` | Send to quickfix list |
| i | `<ScrollWheelUp>` | Preview scroll up |
| i | `<ScrollWheelDown>` | Preview scroll down |

---

## Git (`git.lua`)

### Gitsigns
| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>gn` | Next hunk |
| n | `<leader>gp` | Previous hunk |
| n | `<leader>gs` | Stage hunk |
| n | `<leader>gr` | Reset hunk |
| n | `<leader>gS` | Stage buffer |
| n | `<leader>gR` | Reset buffer |
| n | `<leader>gu` | Undo stage hunk |
| n | `<leader>gv` | Preview hunk |
| n | `<leader>gB` | Toggle line blame |
| n | `<leader>gd` | Diff this |
| n | `<leader>gD` | Diff this (against ~) |
| o, x | `ih` | Select hunk (text object) |

### Git Blame / Snacks
| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>tb` | Toggle git blame |
| n | `<leader>gg` | Git browse (open remote) |
| n | `<leader>gf` | Lazygit current file history |
| n | `<leader>gl` | Lazygit log (cwd) |

---

## UI & Toggles (`ui.lua` — Snacks.nvim)

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader><leader>` | Command line |
| n | `<leader>q` | Delete buffer |
| n | `<leader>rf` | Rename file |
| n | `<leader>e` | File explorer |
| n | `]]` | Next reference |
| n | `[[` | Previous reference |

### Option Toggles
| Mode | Key | Toggle |
|------|-----|--------|
| n | `<leader>ts` | Spelling |
| n | `<leader>tw` | Word wrap |
| n | `<leader>tL` | Relative line numbers |
| n | `<leader>td` | Diagnostics |
| n | `<leader>tl` | Line numbers |
| n | `<leader>tT` | Treesitter |
| n | `<leader>th` | Inlay hints |

---

## Trouble — Diagnostics (`trouble.lua`)

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>xx` | Diagnostics (project) |
| n | `<leader>xX` | Diagnostics (buffer) |
| n | `<leader>cs` | Symbols |
| n | `<leader>cl` | LSP definitions/references |
| n | `<leader>xL` | Location list |
| n | `<leader>xQ` | Quickfix list |

---

## Buffer Line (`line-buffers.lua`)

| Mode | Key | Action |
|------|-----|--------|
| n | `<S-h>` | Previous buffer |
| n | `<S-l>` | Next buffer |
| n | `[b` | Move buffer left |
| n | `]b` | Move buffer right |
| n | `<leader>bb` | Maximize/minimize split |
| n | `<leader>bp` | Toggle pin |
| n | `<leader>bP` | Delete non-pinned buffers |
| n | `<leader>bo` | Delete other buffers |
| n | `<leader>br` | Delete buffers to the right |
| n | `<leader>bl` | Delete buffers to the left |

---

## Folding (`line-column.lua` — nvim-ufo)

| Mode | Key | Action |
|------|-----|--------|
| n | `zR` | Open all folds |
| n | `zM` | Close all folds |
| n | `zr` | Open folds except kinds |
| n | `zm` | Close folds with |
| n | `zs` | Peek fold / show hover |

---

## Code Style & Formatting (`code-style.lua`)

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>ll` | Trigger linting |
| n, v | `<leader>lf` | Format file/selection |

---

## Substitution (`substitution.lua`)

| Mode | Key | Action |
|------|-----|--------|
| n | `so` | Substitute with motion |
| n | `ss` | Substitute line |
| n | `S` | Substitute to end of line |
| x | `s` | Substitute in visual mode |

### Mini.surround
| Key | Action |
|-----|--------|
| `sa` | Add surrounding pair |
| `sd` | Delete surrounding pair |
| `sr` | Replace surrounding pair |
| `sf` | Find surrounding (right) |
| `sF` | Find surrounding (left) |
| `sh` | Highlight surrounding |

### Mini.comment
| Key | Action |
|-----|--------|
| `gc` | Toggle comment (motion/visual) |
| `gcc` | Toggle comment line |

---

## Todo Comments (`todo-comments.lua`)

| Mode | Key | Action |
|------|-----|--------|
| n | `]t` | Next todo comment |
| n | `[t` | Previous todo comment |

---

## AI & Copilot (`copilot.lua`)

| Mode | Key | Action |
|------|-----|--------|
| i | `<C-l>` | Accept Copilot suggestion |
| n, x | `<leader>cc` | Toggle Claude Code |
| n | `<leader>ab` | Add buffer to Claude |
| n | `<leader>aa` | Accept diff |
| n | `<leader>ad` | Reject diff |
| v | `<leader>cC` | Send selection to Claude |

---

## Markdown (`markdown.lua`)

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>mp` | Toggle markdown preview |
| n | `<leader>pi` | Paste image |

---

## Quick Reference by Prefix

| Prefix | Domain |
|--------|--------|
| `<leader>a` | AI/Claude (aa, ab, ad) |
| `<leader>b` | Buffers (ba, bb, bc, bl, bo, bp, bP, br, bu, bv) |
| `<leader>c` | Code actions / Copilot / Symbols (ca, cc, cC, cl, cs) |
| `<leader>d` | Diagnostics (d, D) |
| `<leader>e` | Explorer |
| `<leader>f` | Find/Telescope (fb, fc, ff, fg, fh, fn, fr, fs, ft) |
| `<leader>g` | Git (B, d, D, f, g, l, n, p, r, R, s, S, u, v) |
| `<leader>l` | Lint/Format (f, l) |
| `<leader>m` | Markdown (p) |
| `<leader>n` | Neovim (nh) |
| `<leader>o` | Open (o, os) |
| `<leader>p` | Paste (i) |
| `<leader>q` | Quit buffer |
| `<leader>r` | Rename / LSP restart (f, n, s) |
| `<leader>t` | Toggles (b, d, h, l, L, s, T, w) |
| `<leader>x` | Trouble/diagnostics (L, Q, x, X) |
| `<leader><leader>` | Command line |
| `[` / `]` | Navigation (b, d, t, `[`, `]`) |
