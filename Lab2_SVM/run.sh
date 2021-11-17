# Runs both models on the same dataset gridsearching for nu and sigma^2
# Generates a CSV containing the resulting hyperplane

# Config
TRAIN_FILENAME="train.dat"
AMPL_PATH="/Applications/ampl_macos64"
export PATH=${PATH}:${AMPL_PATH}
export LC_ALL=C

# Data

echo "dataset;num_features;nu;sigmasq;model;cpusec;acc"
for dataset_str in "train_50.dat test_50.dat 4 50" "rice_50.dat rice_test_50.dat 7 50"; do
	dataset=$(echo ${dataset_str}				| awk '{print $1}')
	dataset_test=$(echo ${dataset_str}	| awk '{print $2}')
	num_features=$(echo ${dataset_str}	| awk '{print $3}')
	num_data=$(echo ${dataset_str}			| awk '{print $4}')

	cp "${dataset}" "${TRAIN_FILENAME}"

	for model in ./SVM.run ./DualSVM.run; do
		for nu in 0 0.001 0.01 0.1 0.5 1 5 10 100; do
			res1=$(date +%s)
			out=$(printf "${num_features}\n${num_data}\n${nu}" | $model | tail -n $(expr ${num_features} + 1) | cut -d" " -f3- | tr '\n;' ' ')
			acc=$(./accuracy.R ${dataset_test} ${num_features} ${out})
			res2=$(date +%s)
			out=$(echo ${out} | tr ' ' ',')
			echo "$dataset_test;${num_data};$nu;n/a;$model;$(echo "$res2 - $res1" | bc);$acc"
		done;
	done;

	model="./GaussianSVM.run"
	for sigmasq in  0.01  0.1 0.2 0.5 1  5 10  100; do
		for nu in 0 0.001 0.01 0.1 0.5 1 5 10 100; do
			res1=$(date +%s)
			out=$(printf "${num_features}\n${num_data}\n${sigmasq}\n${nu}" | $model | tail -n $(expr ${num_data} + 1) | cut -d" " -f3- | tr '\n;' ' ')
			acc=$(./accuracy_gaussian.R ${dataset_test} ${sigmasq} ${num_data} ${out})
			res2=$(date +%s)
			out=$(echo ${out} | tr ' ' ',')
			echo "$dataset_test;${num_data};$nu;${sigmasq};$model;$(echo "$res2 - $res1" | bc);$acc"
		done;
	done


done
