boost=($(ls boost-*))
for i in "${boost[@]}"
do
  brew install "${i%.*}"
done

brew list|grep boost-*|xargs brew unlink>/dev/null
