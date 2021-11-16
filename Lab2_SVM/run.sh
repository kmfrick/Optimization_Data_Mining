# Runs both models on the same dataset
# - nu from 0.1 to 5
# - Generates a CSV containing the resulting hyperplane

# Config
MODEL_FILENAME="train.dat"
AMPL_PATH="/Applications/ampl_macos64"
export PATH=${PATH}:${AMPL_PATH}
export LC_ALL=C

# Data

echo "dataset;num_param;nu;model;cpusec;params;acc"
for dataset_str in "test_50.dat 4 50" "rice.dat 7 3809"; do
	dataset=$(echo ${dataset_str}		| awk '{print $1}')
	num_param=$(echo ${dataset_str} | awk '{print $2'})
	num_data=$(echo ${dataset_str}	| awk '{print $3}')

	cp "${dataset}" "${MODEL_FILENAME}"

	for model in ./SVM.run ./DualSVM.run; do
		for nu in 0.1 0.5 1 5; do
			res1=$(date +%s)
			out=$(printf "${num_param}\n${num_data}\n${nu}" | $model | tail -n $(expr ${num_param} + 1) | cut -d" " -f3-)
			out=$(echo $out | sed 's/\ /,/g')
			res2=$(date +%s)
			acc=$(echo "$dataset,${num_data},$nu,$model,$(echo "$res2 - $res1" | bc), $out" | ./accuracy.R ${num_param} | sed -e 's/\ /,/g')
			echo "$dataset;${num_data};$nu;$model;$(echo "$res2 - $res1" | bc);$out;$acc"
		done;
	done;

	model="./GaussianSVM.run"
		for nu in 0.1 0.5 1 5; do
			res1=$(date +%s)
			out=$(printf "${num_param}\n${num_data}\n${nu}" | $model | tail -n $(expr ${num_data} + 1) | cut -d" " -f3-)
			out=$(echo $out | sed 's/\ /,/g')
			res2=$(date +%s)
			acc=$(echo "$dataset,${num_data},$nu,$model,$(echo "$res2 - $res1" | bc), $out" | ./accuracy_gaussian.R ${num_data} | sed -e 's/\ /,/g')
			echo "$dataset;${num_data};$nu;$model;$(echo "$res2 - $res1" | bc);$out;$acc"
		done;
done
