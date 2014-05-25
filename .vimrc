" Show line numbers
set nu

" Indent settings
set ai     "auto indent
set si     "smart indent

" Enable mouse scrollwheel
set mouse=a

" Wrap lines
set wrap

" Highlight searches
set hlsearch

" Tab is equal to 4 spaces
set sw=4     "shift width
set ts=4     "tab stop

" Syntax highlighting
syntax enable	

" Automatically read when file changes
set autoread

" Pathogen
execute pathogen#infect()

" Unicode support
set encoding=utf-8

" Numbered tabs
set tabline=%!MyTabLine()
function MyTabLine()
  let s = '' " complete tabline goes here
  " loop through each tab page
  for t in range(tabpagenr('$'))
    " select the highlighting for the buffer names
    if t + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    " empty space
    let s .= ' '
    " set the tab page number (for mouse clicks)
    let s .= '%' . (t + 1) . 'T'
    " set page number string
    let s .= t + 1 . ' '
    " get buffer names and statuses
    let n = ''  "temp string for buffer names while we loop and check buftype
    let m = 0 " &modified counter
    let bc = len(tabpagebuflist(t + 1))  "counter to avoid last ' '
    " loop through each buffer in a tab
    for b in tabpagebuflist(t + 1)
      " buffer types: quickfix gets a [Q], help gets [H]{base fname}
      " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
      if getbufvar( b, "&buftype" ) == 'help'
        let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
      elseif getbufvar( b, "&buftype" ) == 'quickfix'
        let n .= '[Q]'
      else
        let n .= pathshorten(bufname(b))
        "let n .= bufname(b)
      endif
      " check and ++ tab's &modified count
      if getbufvar( b, "&modified" )
        let m += 1
      endif
      " no final ' ' added...formatting looks better done later
      if bc > 1
        let n .= ' '
      endif
      let bc -= 1
    endfor
    " add modified label [n+] where n pages in tab are modified
    if m > 0
      "let s .= '[' . m . '+]'
      let s.= '+ '
    endif
    " add buffer names
    if n == ''
      let s .= '[No Name]'
    else
      let s .= n
    endif
    " switch to no underlining and add final space to buffer list
    "let s .= '%#TabLineSel#' . ' '
    let s .= ' '
  endfor
  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999XX'
  endif
  return s
endfunction


set t_Co=256
set background=dark
colorscheme tomorrow-night

" Statusline
let g:last_mode = ''
function! Mode()
	let l:mode = mode()
 
	if l:mode !=# g:last_mode
		let g:last_mode = l:mode
 
		hi User1 ctermfg=22 cterm=BOLD
 
		if l:mode ==# 'n'
			hi User1 ctermfg=1
		elseif l:mode ==# "i"
			hi User1 ctermfg=2 
		elseif l:mode ==# "R"
			hi User1 ctermfg=3 
		elseif l:mode ==? "v" || l:mode ==# "^V"
			hi User1 ctermfg=4 
		endif
	endif 
 
	if l:mode ==# "n"
		return "  NORMAL "
	elseif l:mode ==# "i"
		return "  INSERT "
	elseif l:mode ==# "R"
		return "  REPLACE "
	elseif l:mode ==# "v"
		return "  VISUAL "
	elseif l:mode ==# "V"
		return "  V·LINE "
	elseif l:mode ==# "^V"
		return "  V·BLOCK "
	else
		return l:mode
	endif
endfunction

" Statusline colors
hi User1 ctermfg=1
hi User2 ctermfg=2
hi User3 ctermfg=3
hi User4 ctermfg=4
hi User5 ctermfg=5
hi User6 ctermfg=6
hi User7 ctermfg=7
hi User8 ctermfg=1

set laststatus=2
set statusline=%1*%{Mode()}%*
set statusline+=%#StatusLine#
set statusline+=%3*
set statusline+=%=
set statusline+=%3*
set statusline+=%#StatusLine#
set statusline+=%4*\ %{strlen(&fileformat)>0?&fileformat.'\ \ ':''}
set statusline+=%5*%{strlen(&fileencoding)>0?&fileencoding.'\ \ ':''}
set statusline+=%6*%{strlen(&filetype)>0?&filetype.'\ ':''}
set statusline+=%8*\ %p%%\ 
set statusline+=%2*%l:%c\ 

hi TabLine ctermfg=0 ctermbg=7
hi TabLineFill ctermfg=0 ctermbg=7

