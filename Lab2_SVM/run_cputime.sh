# Runs both models on datasets of different sizes

# Config
TRAIN_FILENAME="train.dat"
AMPL_PATH="/Applications/ampl_macos64"
export PATH=${PATH}:${AMPL_PATH}
export LC_ALL=C

# Data

echo "dataset;num_param;nu;sigmasq;model;cpusec;acc"
for m in 50 100 500 1000 2000; do
	for dataset_str in "train_${m}.dat test_${m}.dat 4 ${m}" "rice_${m}.dat rice_test_${m}.dat 7 ${m}"; do
		dataset=$(echo ${dataset_str}				| awk '{print $1}')
		dataset_test=$(echo ${dataset_str}	| awk '{print $2}')
		num_param=$(echo ${dataset_str}			| awk '{print $3'})
		num_data=$(echo ${dataset_str}			| awk '{print $4}')
		nu=5

		cp "${dataset}" "${TRAIN_FILENAME}"
		for model in ./SVM.run ./DualSVM.run; do
			res1=$(date +%s)
			out=$(printf "${num_param}\n${num_data}\n${nu}" | $model | tail -n $(expr ${num_param} + 1) | cut -d" " -f3-)
			out=$(echo $out | sed 's/\ /,/g')
			acc=$(echo "$dataset_test,${num_data},$nu,$model,$(echo "$res2 - $res1" | bc), $out" | ./accuracy.R ${num_param} | sed -e 's/\ /,/g')
			res2=$(date +%s)
			echo "$dataset_test;${num_data};$nu;n/a;$model;$(echo "$res2 - $res1" | bc);$acc"
		done;

	done
done
