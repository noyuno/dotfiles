LATEXMK := $(shell command -v latexmk 2> /dev/null)
LATEXMKOPTION :=
TARGET := report.pdf
SOURCE := report.tex
MARKDOWN :=  $(shell find -path ./report.md)

.PHONY: build clean distclean show filer

build:
ifdef MARKDOWN
	pandoc -o reportc.tex $(MARKDOWN)
endif
ifdef LATEXMK
	latexmk -pdfdvi $(LATEXMKOPTION) $(SOURCE)
else
	uplatex -interaction=batchmode -shell-escape $(SOURCE)
	dvipdfmx report.dvi
endif

clean:
	$(RM) *.aux *.dvi *.log *.fdb_latexmk *.fls *.synctex.gz *.out reportc.tex

distclean: clean
	$(RM) $(TARGET)

show: build
	xdg-open $(TARGET)

filer: build
	caja .

