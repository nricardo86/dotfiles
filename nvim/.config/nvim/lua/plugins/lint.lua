return {
    "mfussenegger/nvim-lint",
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            -- javascript = { "eslint" },
            -- typescript = { "eslint" },
            -- html = { "htmlhint" },
            -- css = { "stylelint" },
            -- bash = { "shellcheck" },
            -- lua = { "luacheck" },
            -- json = { "jsonlint-php" },
            -- python = { "pylint" },
            -- c = { "cpplint" },
        }

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = vim.api.nvim_create_augroup("lint", { clear = true }),
            callback = function()
                lint.try_lint()
            end,
        })

        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, { desc = "Trigger [l]inting for current file" })
    end,
}
