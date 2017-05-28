$latex = 'uplatex -interaction=batchmode -shell-escape -synctex=1 %O %S';
$bibtex = 'pbibtex %O %B';
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'mendex %O -o %D %S';
$max_repeat = 4;
$pdf_previewer = 'xdg-open'

