import sys
import re
import os
import subprocess
import glob

fixed_scv_nam_base = 'data/data_'

def run(command) :
	subprocess.call(command.split())

def fix_csv(csv_files) :
	i = 0
	for csv_file in csv_files :
		i = i + 1
		with open(csv_file) as csv :
			csv_lines = csv.readlines()
			fixed_scv_name = fixed_scv_nam_base + str(i) + ".csv"
			with open(fixed_scv_name, "w") as data :
				data.seek(0)
				data.truncate()
				if (csv_lines[0]).count(';') == 4 :
					data.write('"Date";"Date2";"Place";"CurrencyAmount";"Amount"\n')
				else :
					data.write('"Date";"Date2";"Currency";"Place";"Type";"City";"Country";"Amount";"AbsAmount"\n')
				
				for line in csv_lines :
					line = re.sub(r"(Card \*{3})\d+", "", line)
					line = line.replace(",", "")
					line = line.replace("; ", ";")
					data.write(line) 

def check_dir(dir_name) : 
	if (not os.path.isdir(dir_name)) :
		os.mkdir(dir_name)		

def main() :
	csv_files = glob.glob("*.csv")
	if len(csv_files) == 1 :
		print('Please provide at least one csv file\n')
		sys.exit(1)

	check_dir("output")
	check_dir("data")
	for data in glob.glob("data/*.csv") :
		os.remove(data)

	fix_csv(csv_files)

	fixed_csv_names = ""
	for data in glob.glob("data/*.csv") :
		fixed_csv_names = fixed_csv_names + data + " "

	run('Rscript.exe show_me_the_money.R ' + fixed_csv_names)
	
	print('Done')

if __name__ == '__main__':
    main()
