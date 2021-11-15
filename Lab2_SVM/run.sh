# Runs both models on the same dataset
# - NU from 0.1 to 1 in steps of 1
# - Generates a CSV containing the resulting hyperplane

# Config
MODEL_FILENAME="train.dat"
AMPL_PATH="/home/uni/ampl/ampl_linux-intel64"
export PATH=${PATH}:${AMPL_PATH}
export LC_ALL=C

# Data
DATASET="rice.dat"
NUM_PARAM=7
m=3809


dataset=$(sed -e 's/\*//g' ${DATASET})
cp "${DATASET}" "${MODEL_FILENAME}"

for model in ./SVM.run ./DualSVM.run; do
	for NU in 0.1 0.5 1 5; do
		res1=$(date +%s.%N)
		out=$(printf "${NUM_PARAM}\n${m}\n${NU}" | $model | tail -n $(expr ${NUM_PARAM} + 1) | cut -d" " -f3-)
		out=$(echo $out | sed 's/\ /,/g')
		res2=$(date +%s.%N)
		acc=$(echo "$DATASET,${m},$NU,$model,$(echo "$res2 - $res1" | bc), $out" | ./accuracy.R)
		echo "$DATASET,${m},$NU,$model,$(echo "$res2 - $res1" | bc),$out,$acc"
	done;
done;
