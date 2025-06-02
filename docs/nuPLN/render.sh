for i in {1..3}; do
    bibtex nuPLN
    lualatex -shell-escape nuPLN.tex
done
