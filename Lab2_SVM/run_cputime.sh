# Runs both models on datasets of different sizes
millis(){  python3 -c "import time; print(int(time.time()*1000))"; }

# Config
TRAIN_FILENAME="train.dat"
AMPL_PATH="/Applications/ampl_macos64:$HOME/ampl/ampl_linux-intel64"
export PATH=${PATH}:${AMPL_PATH}
export LC_ALL=C

# Data

echo "dataset;num_features;nu;sigmasq;model;cputime;acc"
for m in 10 50 100 300 900; do
	for dataset_str in "train_${m}.dat test_${m}.dat 4 ${m}" "randgen_${m}.dat randgen_test_${m}.dat 2 ${m}"; do
		dataset_train=$(echo ${dataset_str}				| awk '{print $1}')
		dataset_test=$(echo ${dataset_str}	| awk '{print $2}')
		num_features=$(echo ${dataset_str}			| awk '{print $3}')
		num_data=$(echo ${dataset_str}			| awk '{print $4}')
		nu=5

		cp "${dataset_train}" "${TRAIN_FILENAME}"
		for model in ./SVM.run ./DualSVM.run; do
			res1=$(millis)
			out=$(printf "${num_features}\n${num_data}\n${nu}" | $model | tail -n $(expr ${num_features} + 1) | cut -d" " -f3-)
			acc=$(./accuracy.R ${dataset_train} ${dataset_test} ${num_features} ${out} | sed -e 's/\ /,/g')
			res2=$(millis)
			echo "$dataset_test;${num_data};$nu;n/a;$model;$(echo "$res2 - $res1" | bc);$acc"
		done;

	done
done
