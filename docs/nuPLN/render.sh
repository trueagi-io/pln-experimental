for i in {1..3}; do
    bibtex nuPLN
    pdflatex -shell-escape nuPLN.tex
done
