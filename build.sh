#!/bin/sh

echo "Création de l'index..."
for i in `find posts -type d -maxdepth 1 -mindepth 1`; do
  file=$(basename $i)
  title=`grep -e '\\postTitle{.*}' $i/main.tex | sed 's/\\\\postTitle{\(.*\)}/\1/'`
  description=`grep -e '\\postDescription{.*}' $i/main.tex | sed 's/\\\\postDescription{\(.*\)}/\1/'`

  if [[ $title != "" ]]; then
    echo "\\postPreview{$title}{$description}{$file.pdf}" >> main.tex
  fi
done
mkdir posts/index
mv main.tex posts/index

echo "Compilation des posts..."
for i in `find posts -type d -maxdepth 1 -mindepth 1`; do
  mkdir tmp

  cp -R base/* tmp
  cp -r $i/* tmp 

  file=$(basename $i)
  echo "++++ $file..."
  cd tmp && gsed -i 's/@__POST__@/main/g' body.tex && pdflatex body.tex && cd ..
  cp tmp/body.pdf bin/${file}.pdf

  rm -rf tmp/
done

rm -r posts/index

echo ""
echo "Terminé."
