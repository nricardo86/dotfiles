return {
    {
        "Wansmer/treesj",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        lazy = false,
        config = function()
            -- default keymaps are disabled: treesj's `<space>s` would shadow the
            -- snacks.nvim `<leader>s*` picker mappings
            require("treesj").setup({
                use_default_keymaps = false,
            })

            local treesj = require("treesj")
            vim.keymap.set("n", "<leader>m", treesj.toggle, { desc = "[T]reesitterJ toggle" })
            vim.keymap.set("n", "<leader>mj", treesj.join, { desc = "[T]reesitterJ join" })
            vim.keymap.set("n", "<leader>ms", treesj.split, { desc = "[T]reesitterJ split" })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",              -- Nvim 0.12 requires the rewritten `main` branch
        lazy = false,                 -- the `main` branch does not support lazy-loading
        build = ":TSUpdate",
        opts = {
            -- parsers + queries are installed here; the dir is prepended to `runtimepath`
            install_dir = vim.fn.stdpath("data") .. "/site",
        },
        config = function(_, opts)
            require("nvim-treesitter").setup(opts)

            local augroup = vim.api.nvim_create_augroup("treesitter", { clear = true })
            local installing = {}

            vim.api.nvim_create_autocmd("FileType", {
                group = augroup,
                callback = function(ev)
                    local ft = vim.bo[ev.buf].filetype
                    if ft == "" then
                        return
                    end

                    -- filetype -> parser language (nvim-treesitter registers these)
                    local lang = vim.treesitter.language.get_lang(ft)
                    if not lang then
                        return
                    end

                    -- only handle buffers whose parser is available
                    local ok, parser = pcall(vim.treesitter.get_parser, ev.buf, lang, { error = false })
                    if not ok or not parser then
                        -- parser missing: fetch it in the background, once per language
                        if not installing[lang] and require("nvim-treesitter.parsers")[lang] then
                            installing[lang] = true
                            vim.notify("Installing treesitter parser: " .. lang, vim.log.levels.INFO)
                            require("nvim-treesitter").install({ lang }):await(function(err)
                                installing[lang] = nil
                                if err then
                                    vim.notify(
                                        "Failed to install " .. lang .. " parser: " .. tostring(err),
                                        vim.log.levels.WARN
                                    )
                                end
                            end)
                        end
                        return
                    end

                    -- highlighting (core Neovim) + indentation (nvim-treesitter)
                    pcall(vim.treesitter.start, ev.buf, lang)
                    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
}
