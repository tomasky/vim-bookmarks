if !exists("g:line_map")
  let g:line_map = {}  "  'line_nr'  => 'bookmark'
  let g:sign_map = {}  "  'sign_idx' => 'line_nr'
endif

" Bookmark Model {{{

function! bm#has_bookmarks_in_file(file)
  if !has_key(g:line_map, a:file)
    return 0
  endif
  return len(keys(g:line_map[a:file])) > 0
endfunction

function! bm#has_bookmark_at_line(file, line_nr)
  if !has_key(g:line_map, a:file)
    return 0
  endif
  return has_key(g:line_map[a:file], a:line_nr)
endfunction

function! bm#get_bookmark_by_line(file, line_nr)
  return g:line_map[a:file][a:line_nr]
endfunction

function! bm#get_bookmark_by_sign(file, sign_idx)
  let l:line_nr = g:sign_map[a:file][a:sign_idx]
  return bm#get_bookmark_by_line(a:file, l:line_nr)
endfunction

function! bm#add_bookmark(file, sign_idx, line_nr, content)
  if !has_key(g:line_map, a:file)
    let g:line_map[a:file] = {}
    let g:sign_map[a:file] = {}
  endif
  let l:entry = {'sign_idx': a:sign_idx, 'line_nr': a:line_nr, 'content': a:content}
  let g:line_map[a:file][a:line_nr]  = l:entry
  let g:sign_map[a:file][a:sign_idx] = a:line_nr
endfunction

function! bm#update_bookmark_for_sign(file, sign_idx, new_line_nr, new_content)
  let l:bookmark = bm#get_bookmark_by_sign(a:file, a:sign_idx)
  call bm#del_bookmark_at_line(a:file, l:bookmark['line_nr'])
  call bm#add_bookmark(a:file, a:sign_idx, a:new_line_nr, a:new_content)
endfunction

function! bm#del_bookmark_at_line(file, line_nr)
  let l:bookmark = bm#get_bookmark_by_line(a:file, a:line_nr)
  unlet g:line_map[a:file][a:line_nr]
  unlet g:sign_map[a:file][l:bookmark['sign_idx']]
  if empty(g:line_map[a:file])
    unlet g:line_map[a:file]
    unlet g:sign_map[a:file]
  endif
endfunction

function! bm#all_bookmarks_by_line(file)
  if !has_key(g:line_map, a:file)
    return {}
  endif
  return g:line_map[a:file]
endfunction

function! bm#all_lines(file)
  if !has_key(g:line_map, a:file)
    return []
  endif
  return keys(g:line_map[a:file])
endfunction

function! bm#all_files()
  return keys(g:line_map)
endfunction

function! bm#del_all()
  for l:file in keys(g:line_map)
    for l:line_nr in keys(g:line_map[l:file])
      call bm#del_bookmark_at_line(l:file, l:line_nr)
    endfor
  endfor
endfunction

" }}}