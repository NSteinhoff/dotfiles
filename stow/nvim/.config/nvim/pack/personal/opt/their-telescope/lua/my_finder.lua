local my_finder = {}

function my_finder.find(cwd)
    if vim.fn.finddir('.git', cwd..';') == '' then
        require'telescope.builtin'.find_files(cwd == '' and {} or { cwd = cwd })
    else
        require'telescope.builtin'.git_files(opts)
    end
end

return my_finder
