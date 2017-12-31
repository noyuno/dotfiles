LATEXMK := $(shell command -v latexmk 2> /dev/null)
LATEXMKOPTION :=
NAME := thesis
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
	upbibtex $(NAME)
endif

clean:
	$(RM) *.aux *.dvi *.log *.fdb_latexmk *.fls *.synctex.gz *.out reportc.tex *.blg *.bbl *.toc

distclean: clean
	$(RM) $(TARGET)

show: build
	xdg-open $(TARGET)

filer: build
	caja .

