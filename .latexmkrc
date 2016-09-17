$pdflatex = "xelatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S"; $postscript_mode = $dvi_mode = 0;
#$pdflatex = "pdflatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S";
#$pdflatex = "latex -synctex=1 -interaction=nonstopmode -file-line-error %O %S";
# add --shell-escape will have live-update function in some file
$pdf_mode = 1;
$bibtex_use = 2;
#$print_type = "pdf";
#$view = "pdf";
$pdf_previewer = "open -a /Applications/Skim.app %S";
$pdf_update_method = 0;
#$pdf_update_command = '/usr/bin/osascript -e "set theFile to POSIX file \"%S\" as alias" -e "set thePath to POSIX path of theFile" -e "tell application \"Skim\"" -e "  set theDocs to get documents whose path is thePath" -e "  try" -e "    if (count of theDocs) > 0 then revert theDocs" -e "  end try" -e "  open theFile" -e "end tell"';
#$pdf_update_command = 'osascript -e \'tell application "Skim" to revert document %S\'';
$clean_ext = "paux lox pdfsync out";
$force_mode = 1;
$recorder = 1;

