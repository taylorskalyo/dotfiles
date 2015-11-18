" Show line numbers
set number

" Unicode support
set encoding=utf-8

" Enable mouse scrollwheel
set mouse=a

" Enable SGR mouse reporting
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end

" Wrap lines
set wrap

" Highlight searches
set hlsearch

" Indent settings
set autoindent
filetype plugin indent on

" Tab is equal to 2 spaces
set shiftwidth=2
set tabstop=2
set expandtab

" Highlight current line (slows down scrolling)
"set cursorline

" Show trailing spaces and tabs
set list listchars=tab:│\ ,trail:·

" Syntax highlighting
syntax enable

" Folding
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent

" Check for file-specific vim settings
set modelines=1

" Search as characters are entered
set incsearch

" Redraw only when necessary
set lazyredraw

" Move temporary files to tmp directory
set bdir-=.
set bdir+=/tmp
set dir-=.
set dir+=/tmp

" Automatically read when file changes
set autoread

" Use the system clipboard if using tmux
if $TMUX == ''
  set clipboard+=unnamed
endif

" Pathogen
execute pathogen#infect()

" CtrP
set runtimepath^=~/.vim/bundle/ctrlp.vim

" More natural splits
set splitbelow
set splitright
set fillchars=vert:│

" Move to nex/previous line with same indentation
nnoremap [b :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>
nnoremap ]b :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>

" Tagbar
nnoremap \t :TagbarToggle<CR>

" NerdTree
nnoremap \n :NERDTreeToggle<CR>

" CopyMatches
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/ge
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

" Numbered tabs {{{
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
" }}}

" Colors
set t_Co=256
set background=dark
colorscheme tomorrow-night

" Status Line {{{
" Statusline Mode
hi User9 ctermfg=1
let g:last_mode = ''
function! Mode()
  let l:mode = mode()

  if l:mode !=# g:last_mode
    let g:last_mode = l:mode

    if l:mode ==# 'n'
      hi User9 ctermfg=9 " Red
    elseif l:mode ==# "i"
      hi User9 ctermfg=10 " Green
    elseif l:mode ==# "R"
      hi User9 ctermfg=11 " Yellow
    elseif l:mode ==? "v" || l:mode ==# "^V"
      hi User9 ctermfg=12 " Blue
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
hi User1 ctermfg=9 " Red
hi User2 ctermfg=10 " Green
hi User3 ctermfg=11 " Yellow
hi User4 ctermfg=12 " Blue
hi User5 ctermfg=13 " Magenta
hi User6 ctermfg=14 " Cyan
hi User7 ctermfg=7 " White
hi User8 ctermfg=8 " Black
" User9 changes based on the current mode

" Statusline content
set laststatus=2
set statusline=
set statusline=%9*%{Mode()}%* " Mode
set statusline+=%8*
set statusline+=%=            " Separator
set statusline+=%5*
set statusline+=\ %.40f       " Filename
set statusline+=%4*
set statusline+=%{strlen(&filetype)>0?'\ '.&filetype:''} " Filetype
set statusline+=%6*
set statusline+=\ %P          " Percentage through file
set statusline+=%2*
set statusline+=\ %-6(%l:%c%) " Line:Col
" }}}

" Tabline
hi TabLine ctermfg=0 ctermbg=7
hi TabLineFill ctermfg=0 ctermbg=7

" Ruler
set colorcolumn=80

" Speed up CtrlP with ag
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden -g ""'

" Jump between if, else, do, case, when, end, etc. in ruby code
runtime macros/matchit.vim

" Specific vim settings for this file
" vim:foldmethod=marker:foldlevel=0
