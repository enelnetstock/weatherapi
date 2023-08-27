#!/bin/bash
asciiindex "$1"
#a2x -a docinfo -fpdf "$1"
a2x -a docinfo -fpdf --dblatex-opts="-s asciidoc-dblatex-custom.sty" "$1"
a2x -a docinfo -fxhtml "$1"
