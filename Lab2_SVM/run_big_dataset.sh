# Runs both models on the same dataset
# - nu from 0.1 to 5
# - Generates a CSV containing the resulting hyperplane
millis(){  python -c "import time; print(int(time.time()*1000))"; }

# Config
TRAIN_FILENAME="train.dat"
AMPL_PATH="/Applications/ampl_macos64"
export PATH=${PATH}:${AMPL_PATH}
export LC_ALL=C

# Data

echo "dataset;num_features;nu;sigmasq;model;cputime;acc"
for dataset_str in "train_50.dat test_10000.dat 4 50 10000" "randgen_50.dat randgen.dat 2 50 600"; do
	dataset_training=$(echo ${dataset_str}				| awk '{print $1}')
	dataset_test=$(echo ${dataset_str}	| awk '{print $2}')
	num_features=$(echo ${dataset_str}	| awk '{print $3}')
	num_data=$(echo ${dataset_str}			| awk '{print $4}')
	num_data_test=$(echo ${dataset_str}	| awk '{print $5}')

	cp "${dataset_training}" "${TRAIN_FILENAME}"
	sigmasq=1
	nu=10

	for model in ./SVM.run ./DualSVM.run; do
		res1=$(millis)
		out=$(printf "${num_features}\n${num_data}\n${nu}" | $model | tail -n $(expr ${num_features} + 1) | cut -d" " -f3- | tr '\n;' ' ')
		acc=$(./accuracy.R ${dataset_test} ${dataset_training} ${num_features} ${out})
		res2=$(millis)
		out=$(echo ${out} | tr ' ' ',')
		echo "$dataset_test;${num_data};$nu;n/a;$model;$(echo "$res2 - $res1" | bc);$acc"
	done

	model="./GaussianSVM.run"
	res1=$(millis)
	out=$(printf "${num_features}\n${num_data}\n${sigmasq}\n${nu}" | $model | tail -n $(expr ${num_data} + 1) | cut -d" " -f3- | tr '\n;' ' ')
	acc=$(./accuracy_gaussian.R ${dataset_test} ${dataset_training} ${sigmasq} ${num_data} ${out})
	res2=$(millis)
	out=$(echo ${out} | tr ' ' ',')
	echo "$dataset_test;${num_data};$nu;${sigmasq};$model;$(echo "$res2 - $res1" | bc);$acc"


done
