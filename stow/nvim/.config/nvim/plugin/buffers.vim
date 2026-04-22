command! A call buffers#yang()
command! BufDeletHidden call foreach(getbufinfo()->filter({ _, b -> b.hidden })->map({ _, b -> b.bufnr }), "execute 'bdelete '.. v:val")
