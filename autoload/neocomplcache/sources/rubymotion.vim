let s:save_cpo = &cpo
set cpo&vim

let s:iphone_os_version = '6.1'
let s:rubymotion_library_path = '/Library/RubyMotion/'
let s:rubymotion_bridgesupport_path = s:rubymotion_library_path . '/data/' . s:iphone_os_version . '/BridgeSupport'

let s:plugin_path = escape(expand('<sfile>:p:h'), '\')

" for debug

function! s:echom_debug(data)
  echom "== echo_debug == start"
  for line in split(s:each_list_string(a:data), "\n")
    echom line
  endfor
  echom "== echo_debug == end"
endfunction

function! s:each_list_string(list)

  let l:type = type(a:list)

  if l:type == 0 || l:type == 1 || l:type == 5
    return a:list . "\n"
  elseif l:type == 3
    " list
    return join(map(a:list, 's:each_list_string(v:val)'), "\n")
  elseif l:type == 4
    " dict

    let l:ret = []
    let l:datas = map(a:list, 'v:key . ": " . s:each_list_string(v:val)')
    for [key, val] in items(l:datas)
      call add(l:ret, val)
    endfor
    return join(l:ret, "\n")

    let l:ret = ""
    for [key, val] in items(item)
      l:ret =  klret . key . ": " . s:each_list_string(item) . "\n"
    endfor
    return l:ret
  endif

endfunction

function! neocomplcache#sources#rubymotion#define() "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'rubymotion_complete',
      \ 'kind' : 'ftplugin',
      \ 'filetypes' : { 'ruby' : 1 },
      \}

function! s:source.initialize() "{{{
  " Initialize.

  if has('python') && !exists('s:loaded')
    python import sys
    exe 'python sys.path = ["' . s:plugin_path . '"] + sys.path'
    python debug = 0
    exe 'pyfile ' . s:plugin_path . '/read_bridgesupport.py'
    python ret = init_rubymotion_read_bridgesupport(vim.eval('s:rubymotion_bridgesupport_path'))
    python vim.command("let l:res = %s" % ret)

    if l:res == 0
      return 0
    endif
    let s:loaded = 1
  endif

endfunction"}}}

function! s:source.get_keyword_pos(cur_text) "{{{

  return match(a:cur_text, '[^.: \t]*$')

  " if neocomplcache#is_auto_complete() &&
  "       \ a:cur_text !~ '\%([^. *\t]\.\w*\|\h\w*::\)$'
  "   return -1
  " endif

  " return match(a:cur_text, '[^.:]*$')

endfunction"}}}

function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str) "{{{
  " let temp = s:get_temp_name()

  " let candidates = []
  " return candidates

  echom "[vim] cur_keyword_pos = ". a:cur_keyword_pos
  echom "[vim] cur_keyword_str = ". a:cur_keyword_str


  python completions = get_current_completions(vim.eval('a:cur_keyword_pos'), vim.eval('a:cur_keyword_str'))
  python vim.command('let l:res = ' + completions)

  return l:res

endfunction"}}}


let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
