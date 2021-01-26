"---------------------------------------------------------------------------------------

if empty(glob('~/.config/nvim/autoload/plug.vim'))
{
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
}
endif

"---------------------------------------------------------------------------------------

call plug#begin('~/.config/nvim/plugged')

"Markdown 插件    
Plug 'iamcco/markdown-preview.nvim',{'do': { -> mkdp#util#install() },'for': ['markdown', 'vim-plug']}

" 文件管理插件 可以预览目录    
Plug 'scrooloose/nerdtree'        

"自动引号&括号补全插件 Plug jiangmiao/auto-pairs    
Plug 'neoclide/coc.nvim',{'branch': 'release'}

call plug#end() 

"---------------------------------------------------------------------------------------

"set number "显示行号

set nocompatible "去掉有关vi一致性模式，避免以前版本的bug和局限
filetype on "检测文件的类型
set autoindent "vim使用自动对齐，也就是把当前行的对齐格式应用到下一行(自动缩进)
set ruler "在编辑过程中，在右下角显示光标位置的状态行
set incsearch "设置自动匹配单词的位置
set backspace=2
syntax on "语法高亮 
colorscheme murphy "修改配色
set ignorecase "查找时忽略大小写
set nohlsearch "查找匹配到的所有单词不高亮显示，只高亮光标所在单词。

"---------------------------------------------------------------------------------------
" :map 递归映射
" :noremap 非递归映射
" :nnoremap 正常模式映射
" :vnoremap 可视模式和选择模式映射
" :xnoremap 可视模式映射
" :snoremap 选择模式映
" :onoremap 操作待决模式映射
" :noremap! 插入和命令模式映射
" :inoremap 插入模式映射
" :cnoremap 命令模式映射
"
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <C-Left> <C-w><5
noremap <C-Right> <C-w>>5
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
nnoremap ; : 
inoremap <Tab> <C-n>
noremap <F3> :set number!<CR> 
nnoremap <C-w> :w<CR>
vnoremap q b
nnoremap q b
noremap L $
noremap H 0
inoremap jk <Esc>
nnoremap tt :NERDTreeToggle<CR>
nnoremap mk :MarkdownPreview<CR> 
nnoremap MM <C-w>q
nnoremap J <C-e>
nnoremap K <C-y>
nnoremap mg J
inoremap { {}<Esc>i
inoremap ( ()<Esc>i