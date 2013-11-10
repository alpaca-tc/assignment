function! assignment#system#evaluate_command(...) "{{{
  let current_path = getcwd()
  let result = ''

  try
    lcd `=g:assignment#path`
    let result = system('bundle exec rake ' . join(a:000, ' '))
    edit lib
  catch /.*/
    call assignment#message#error(v:errmsg)
    lcd `=current_path`
  finally
    return result
  endtry
endfunction"}}}

function! s:system(...) "{{{
  let current_path = getcwd()

  try
    lcd `=g:assignment#path`
    execute '!bundle exec rake ' . join(a:000, ' ')
  catch /.*/
    call assignment#message#error(v:errmsg)
  finally
    lcd `=current_path`
  endtry
endfunction"}}}

function! assignment#system#do(command, arguments) "{{{
  if a:command =~ '\(register_assignment\|pull_request\|show_assignments\)'
    call s:system(a:command)
  elseif a:command =~ '\(new_assignment\|solve\)'
    call assignment#system#do_with_title(a:command, a:arguments)
  else
    call assignment#message#error('Command is not found!')
  endif
endfunction"}}}

function! assignment#system#do_with_title(command, arguments) "{{{
  let title = len(a:arguments) > 0 ? a:arguments[0] : assignment#input('Please input title: ')
  call s:system(a:command . '\[' . title . '\]')
endfunction"}}}
