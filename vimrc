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

" Unicode support
set encoding=utf-8

set t_Co=256
set background=dark
let g:hybrid_use_Xresources=1
colorscheme hybrid

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
set statusline+=%{&mod?'+':''}
set statusline+=%3*
set statusline+=%#warningmsg#
set statusline+=%=
set statusline+=%3*
set statusline+=%#StatusLine#
set statusline+=%4*\ %{strlen(&fileformat)>0?&fileformat.'\ \ ':''}
set statusline+=%5*%{strlen(&fileencoding)>0?&fileencoding.'\ \ ':''}
set statusline+=%6*%{strlen(&filetype)>0?&filetype.'\ ':''}
set statusline+=%8*\ %p%%\ 
set statusline+=%2*%l:%c\ 
