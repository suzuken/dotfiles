" WriteJSDocComment.vim
" write JSDoc comment
" Version: 0.2
" Author: Hideaki Tanabe <tanablog@gmail.com>
"
" Caution: this script need perl interface (compile with +perlinterp)
" setting: 
"  1.
"   install in ~/.vim/ftplugin/javascript/
"  2.
"   assign keymap at .vimrc for example
"   au FileType javascript nnoremap <buffer> <C-c>  :<C-u>call WriteJSDocComment()<CR>

function! WriteJSDocComment()
if has('perl')
perl << EOF
  # check the function has return parameter
  sub has_return {
    my $row = shift;
    my $brace_count = 1;
    my $i = 0;
    my $limit = 200;
    $row++;
    while (($brace_count > 0) || ($limit < 0)) {
      if ($row > $curbuf->Count()) {
        return false;
      }
      my $line = $curbuf->Get($row);
      $brace_count++ if $line =~ /{/g;
      $brace_count-- if $line =~ /}/g;
      if ($brace_count == 1) {
        return true if $line =~ /return/g;
      }
      $limit--;
      $row++;
    }
    return false;
  }

  # get the name of function
  sub get_function_name {
    $line = shift;
    if ($line =~ /(\w+)\s*(:|=)\s*function/g) {
      return $1;
    } elsif ($line =~ /function \s*(\w+)\s*\(/g) {
      return $1;
    }
    return '';
  }

  my @pos = $curwin->Cursor();
  my $row = @pos[0];
  my $col = @pos[1];
  my $line = $curbuf->Get($row);
  my @params = $line =~ /\((.*)\)/g;
  my $function_name = get_function_name($line);

  @params = split(/\s*,\s*/, @params[0]);
  @params = map {' * @param ' . $_ . " "} @params;
  unshift(@params, (' * @name ' . $function_name, ' * @function'));
  if (has_return($row) eq 'true') {
    push(@params, ' * @return ');
  } 
  my @comments = map {" " x $col . $_} ('/**', ' * ', @params, ' */');
  $curbuf->Append(@pos[0] - 1, @comments);
EOF
endif
endfunction
