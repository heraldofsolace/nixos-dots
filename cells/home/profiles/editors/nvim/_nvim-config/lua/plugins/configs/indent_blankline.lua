require("ibl").setup {
    exclude = {
        filetypes = { 
            "help",
            "terminal",
            "alpha",
            "packer",
            "lspinfo",
            "TelescopePrompt",
            "TelescopeResults",
            "nvchad_cheatsheet",
            "",
        },
        buftypes = { "terminal" }
    },
}