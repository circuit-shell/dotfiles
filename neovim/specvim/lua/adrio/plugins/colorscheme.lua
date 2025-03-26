return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            background = {
                light = "latte",
                dark = "mocha",
            },
            transparent_background = true,
            show_end_of_buffer = false,
            term_colors = false,
            dim_inactive = {
                enabled = false,
                shade = "dark",
                percentage = 0.15,
            },
            no_italic = false,
            no_bold = false,
            no_underline = false,
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            color_overrides = {
                all = {
                    rosewater = "#FFB86C", -- Orange
                    flamingo = "#FF79C6", -- Pink
                    pink = "#FF79C6", -- Pink
                    mauve = "#BD93F9", -- Purple
                    red = "#FF5555", -- Red
                    maroon = "#FF5555", -- Red
                    peach = "#FFB86C", -- Orange
                    yellow = "#F1FA8C", -- Yellow
                    green = "#50FA7B", -- Green
                    teal = "#8BE9FD", -- Cyan
                    sky = "#8BE9FD", -- Cyan
                    sapphire = "#8BE9FD", -- Cyan
                    blue = "#BD93F9", -- Purple
                    lavender = "#FF79C6", -- Pink
                    text = "#F8F8F2", -- Foreground
                    subtext1 = "#F8F8F2", -- Foreground
                    subtext0 = "#BFBFBF", -- Light Gray
                    overlay2 = "#4d4d4d", -- Bright Purple
                    overlay1 = "#7970A9", -- Muted Purple
                    overlay0 = "#6272A4", -- Comment
                    surface2 = "#414458", -- Dark Gray
                    surface1 = "#343746", -- Darker Gray
                    surface0 = "#282A36", -- Background
                    base = "#282A36", -- Background
                    mantle = "#21222C", -- Darker Background
                    crust = "#191A21", -- Darkest Background
                },
            },
            custom_highlights = function(colors)
                return {
                    LineNr = { fg = colors.overlay0 },
                    CursorLineNr = { fg = colors.yellow },
                    CursorLine = { bg = colors.mantle },
                    ColorColumn = { bg = colors.mantle },
                    Visual = { bg = colors.surface1 },
                    MsgArea = { fg = colors.text },
                    TabLine = { bg = colors.mantle },
                    TabLineFill = { bg = colors.mantle },
                    TabLineSel = { fg = colors.text, bg = colors.surface0 },

                    GitSignsAdd = { fg = colors.green },
                    GitSignsChange = { fg = colors.yellow },
                    GitSignsDelete = { fg = colors.red },
                    TelescopeBorder = { fg = colors.overlay0 },

                    -- Syntax highlighting
                    Constant = { fg = colors.blue},
                    String = { fg = colors.yellow },
                    Character = { fg = colors.yellow },
                    Number = { fg = colors.blue},
                    Boolean = { fg = colors.blue},
                    Float = { fg = colors.blue},
                    Identifier = { fg = colors.green },
                    Function = { fg = colors.green },
                    Statement = { fg = colors.pink },
                    Conditional = { fg = colors.pink },
                    Repeat = { fg = colors.pink },
                    Label = { fg = colors.pink },
                    Operator = { fg = colors.pink },
                    Keyword = { fg = colors.pink },
                    Exception = { fg = colors.pink },
                    PreProc = { fg = colors.pink },
                    Include = { fg = colors.pink },
                    Define = { fg = colors.pink },
                    Macro = { fg = colors.pink },
                    PreCondit = { fg = colors.pink },
                    Type = { fg = colors.teal},
                    StorageClass = { fg = colors.pink },
                    Structure = { fg = colors.pink },
                    Special = { fg = colors.pink },
                    SpecialChar = { fg = colors.pink },
                }
            end,
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                notify = false,
                mini = {
                    enabled = true,
                    indentscope_color = "",
                },
            },
        })

        vim.cmd.colorscheme("catppuccin")
    end,
}
