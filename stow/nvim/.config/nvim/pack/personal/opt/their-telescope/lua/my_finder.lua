local my_finder = {}

function my_finder.find(cwd)
    opts = {}
    if cwd ~= '' then
        opts.cwd = cwd
    else
        opts.cwd = vim.fn.getcwd()
    end

    if vim.fn.finddir('.git', opts.cwd..';') == '' then
        require'telescope.builtin'.find_files(opts)
    else
        require'telescope.builtin'.git_files(opts)
    end
end

return my_finder
