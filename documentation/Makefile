TARGET=asciidoc

.PHONY: clean html xml pdf

html: $(TARGET).html

pdf: $(TARGET).pdf

all: html pdf

%.html: %.txt
	#asciiindex $<
	asciidoctor $<

%.pdf: %.txt
	#asciiindex $<
	a2x --no-xmllint -v -a docinfo -fpdf --dblatex-opts="-s asciidoc-dblatex-custom.sty" --dblatex-opts="--param=doc.lot.show=figure,table"  $<
	#pdf2ps asciidoc.pdf && ps2pdf asciidoc.ps && rm asciidoc.ps
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dNOPAUSE -dQUIET -dBATCH -sOutputFile=output.pdf asciidoc.pdf
clean:
	rm -f *~ $(TARGET).pdf $(TARGET).html docbook-xsl.css *.xml

