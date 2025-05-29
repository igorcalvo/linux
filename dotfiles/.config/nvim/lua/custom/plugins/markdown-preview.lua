return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    keys = {
        { 'md', "<cmd>MarkdownPreviewToggle<cr>", desc = "[M]ark[D]own Toggle" }
    },
    build = function() vim.fn["mkdp#util#install"]() end,
}
