TARGET   := report.pdf
TEXNAME  := main.tex
MARKDOWN := $(shell find . -name '*.md')
GIF      := $(shell find . -name '*.gif')
TEX      := $(shell find . -name '*.tex')

.PHONY: build clean distclean show filer

%.tmp.tex: %.md
	pandoc -o $@ $<

%.png: %.gif
	mogrify -format png $<

$(TARGET): $(TEX) $(GIF:gif=png) $(MARKDOWN:md=tmp.tex)
	latexmk -pdfdvi $(TEXNAME)
	mv $(TEXNAME:tex=pdf) $(TARGET)

clean:
	$(RM) *.aux *.dvi *.log *.fdb_latexmk *.fls *.synctex.gz *.out *.tmp.tex

distclean: clean
	$(RM) $(TARGET)

show: $(TARGET)
	xdg-open $(TARGET)

filer: build
	xdg-open .

