
[[ -d Rename ]] || mkdir Rename

x=$1
y=${x#150424Tho_D15-}
y=${y%_sequence*}
sed "s/^.MISEQ.*#/&${y} /g" $x|cut -f1 -d" " > Rename/$x
