LATEXMK := $(shell command -v latexmk 2> /dev/null)
LATEXMKOPTION :=
NAME := slide
TARGET := $(NAME).pdf
SOURCE := $(NAME).tex
MARKDOWN :=  $(shell find -path ./report.md)
DOT := $(wildcard *.dot)
DOTPDF := $(DOT:%.dot=%.pdf)
JPG := $(wildcard *.jpg)
JPGPDF := $(JPG:%.jpg=%.pdf)

.PHONY: build clean distclean show filer

.SUFFIXES: .dot .jpg .pdf

.dot.pdf:
	dot -Tpdf -Gmargin=0 -o $*.pdf $<

.jpg.pdf:
	convert $< -bordercolor "#000000" -border 1x1 $*.pdf

build: $(DOTPDF) $(JPGPDF)
ifdef MARKDOWN
	pandoc -o reportc.tex $(MARKDOWN)
endif
ifdef LATEXMK
	latexmk -pdfdvi $(LATEXMKOPTION) $(SOURCE)
else
	uplatex -interaction=batchmode -shell-escape $(SOURCE)
	dvipdfmx $(NAME).dvi
endif

6up: build
	pdfnup --paper a4paper --no-landscape --scale 0.9 --nup 2x3 --frame true --delta "5mm 20mm" slide.pdf --outfile 6up.pdf
	xdg-open 6up.pdf

clean:
	$(RM) *.aux *.dvi *.log *.fdb_latexmk *.fls *.synctex.gz *.out reportc.tex *.nav *.snm *.toc

distclean: clean
	$(RM) $(TARGET)

show: build
	xdg-open $(TARGET)

filer: build
	caja .

