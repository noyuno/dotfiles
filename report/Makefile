TARGET   := report.pdf
TEXNAME  := main.tex
MARKDOWN := $(shell find . -name '*.md')
GIF      := $(shell find . -name '*.gif')
TEX      := $(shell find . -name '*.tex')
PNGDEST  := pngout

.PHONY: build clean distclean show filer png

%.tmp.tex: %.md
	pandoc --listing -o $@ $<
	# fix table
	sed -i -e 's/\\begin{longtable}/\\vspace{2zh}\\begin{center}\\begin{supertabular}/g' \
		-e 's/\\end{longtable}/\\end{supertabular}\\end{center}\\vspace{2zh}/' \
		-e 's/\\endhead//' \
		$@
	# fix figure
	sed -i -e 's/\\begin{figure}$$/\\begin{figure}[H]/g' \
		-e 's/\\includegraphics{/\\includegraphics[width=12cm]{/g' \
		$@
	# fix inline listing
	sed -i -e 's/\\passthrough{\\lstinline\!\([^!]*\)\!}/\\texttt{\1}/g' \
		-e 's/\\passthrough{\\lstinline"\([^"]*\)"}/\\texttt{\1}/g' \
		-e 's/\\passthrough{\\lstinline'"'"'\([^'"'"']*\)'"'"'}/\\texttt{\1}/g' \
		-e 's/\\passthrough{\\lstinline\*\([^*]*\)\*}/\\texttt{\1}/g' \
		-e 's/\\passthrough{\\lstinline,\([^,]*\),}/\\texttt{\1}/g' \
		$@

%.png: %.gif
	mogrify -format png $<

$(TARGET): $(TEX) $(GIF:gif=png) $(MARKDOWN:md=tmp.tex)
	latexmk -pdfdvi $(TEXNAME)
	mv $(TEXNAME:tex=pdf) $(TARGET)

build: $(TARGET)

clean:
	$(RM) *.aux *.dvi *.log *.fdb_latexmk *.fls *.synctex.gz *.out *.tmp.tex

distclean: clean
	$(RM) $(TARGET)
	rm -rf $(PNGDEST)

show: $(TARGET)
	xdg-open $(TARGET)

filer: build
	xdg-open .

$(PNGDEST): $(TARGET)
	mkdir -p $(PNGDEST)
	pdftoppm $(TARGET) -png -r 350 $(PNGDEST)/$(TARGET:.pdf=)
	pngquant -f --ext .png --speed 1 $(PNGDEST)/*.png

png: $(PNGDEST)

