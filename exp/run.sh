for f in *.py; do  
  ./$f
done

allfile=""
for f in *.ps; do  
  allfile=$allfile" "$f
done
echo $allfile
open $allfile

allfile=""
for f in *.png; do  
  allfile=$allfile" "$f
done
echo $allfile
open $allfile
