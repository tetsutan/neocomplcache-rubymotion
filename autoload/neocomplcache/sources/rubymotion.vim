let s:save_cpo = &cpo
set cpo&vim

function! neocomplcache#sources#rubymotion#define() "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'rubymotion',
      \ 'kind' : 'ftplugin',
      \ 'filetypes' : { 'rubymotion' : 1 },
      \}

function! s:source.initialize() "{{{
  " Initialize.
endfunction"}}}

function! s:source.get_keyword_pos(cur_text) "{{{
  if neocomplcache#is_auto_complete() &&
        \ a:cur_text !~ '\%([^. *\t]\.\w*\|\h\w*::\)$'
    return -1
  endif

  return match(a:cur_text, '[^.:]*$')
endfunction"}}}

function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str) "{{{
  let temp = s:get_temp_name()

  let candidates = []
  return candidates
endfunction"}}}

function! s:get_temp_name() "{{{
  let filename =
        \ neocomplcache#util#substitute_path_separator(tempname())
  let range = neocomplcache#get_context_filetype_range()
  call writefile(getline(range[0][0], range[1][0]), filename)
  return filename
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
