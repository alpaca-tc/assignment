function! assignment#initialize#setup(dir) "{{{
  let dir = fnamemodify(a:dir, ':p:h')
  echo dir
  if isdirectory(dir)
    let path = dir . '/assignment'
    execute '!git clone https://github.com/enfactv/assignment ' . path

    let current_path = getcwd()
    lcd `=path`
    execute '!bundle install'
    lcd `=current_path`

    let command = 'let g:assignment#path = "' . path . '"'
    call assignment#message#error('Please append ' . command . ' to ~/.vimrc')
    let @* = command
  else
    call assignment#message#error('This is not directory!')
  endif
endfunction"}}}
