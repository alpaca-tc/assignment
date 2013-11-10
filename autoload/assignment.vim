let s:command_list = [
      \ 'new_assignment',
      \ 'register_assignment',
      \ 'solve',
      \ 'pull_request',
      \ 'show_assignments',
      \ ]

function! assignment#get_command_names() "{{{
  return copy(s:command_list)
endfunction"}}}

function! s:parse_arguments(value) " {{{
  let line = split(a:value, '\s\+')
  call filter(map(line, 'substitute(v:val, "\s\+", "", "g")'), "!empty(v:val)")

  if empty(line)
    return ['', '']
  endif

  let command = line[0]
  let arguments = len(line) > 1 ? line[1:] : []

  return [command, arguments]
endfunction"}}}

function! s:complete_assignments() "{{{
  if !exists('s:assignments')
    let s:assignments =
          \ split(assignment#system#evaluate_command('show_assignments'), '\(\s\|\n\)\+')
  endif

  return copy(s:assignments)
endfunction"}}}

function! assignment#complete(arg_lead, cmd_line, cursor_pos) " {{{
  " ['ua', 'Assignment next ua', '18']
  let line = substitute(a:cmd_line, '^Assignment ', '', 'g')
  let [command, argument] = s:parse_arguments(line)
  let g:debug = [a:arg_lead, a:cmd_line, a:cursor_pos, command, argument]

  if empty(command)
    return assignment#get_command_names()
  elseif empty(filter(assignment#get_command_names(), 'v:val == command'))
    return filter(assignment#get_command_names(), 'v:val =~ "^" . command')
  elseif command =~ '^\(new_assignment\|solve\)$'
    return filter(s:complete_assignments(), 'v:val =~ "^" . a:arg_lead')
  else
    return []
  endif
endfunction"}}}

function! assignment#do(raw_arguments) " {{{
  let [command, arguments] = s:parse_arguments(a:raw_arguments)

  if !empty(filter(assignment#get_command_names(), 'v:val == command'))
    call assignment#system#do(command, arguments)
  else
    call assignment#message#error('Not found!')
  endif
endfunction"}}}

function! assignment#input(message, ...) "{{{
  let default = len(a:000) > 0 ? a:0 : ''

  while 1
    let input = input(a:message, default)
    if !empty(input)
      return input
    endif
  endwhile
endfunction"}}}
