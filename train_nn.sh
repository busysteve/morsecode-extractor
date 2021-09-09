
total=$(expr $5 + $6)
echo $total
export FACTOR=$2
export PULSE_WIDTH=$3
export GAP_WIDTH=$4
export INPUT_COUNT=$1
rm nn_cw*
./gen-training-data.awk | head -n $total | ./normalize_training.awk  | ./comp-training.awk | ./morsecode-nn - 0 $5 $6
