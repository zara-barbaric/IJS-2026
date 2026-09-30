#!/bin/bash
##SKRIPTA, KI KOPIRA PREDLOGO IN USTVARI SKRIPTO ZA ODDAJANJE PROCESOV NA GRUCO ZA VSAKO KOMBINACIJO VREDNOSTI gt in YTt##

LC_NUMERIC=C
#**pot do mape z vsemi jobi
main_path=~/jobs

for c in $(seq 1 1 21); do #####Spremeni range!!!!
	tag="${c}"
#	cp ${main_path}/job_temp.sh ${main_path}/job_${tag}.sh
	cp ${main_path}/cm_job_temp.sh ${main_path}/cm_job_${tag}.sh

	#Uredi kopirani skripti s pravilnimi vrednostmi gt in ytt
	sed -i "s/(tag)/${tag}/" ${main_path}/job_${tag}.sh
	sed -i "s/(tag)/${tag}/" ${main_path}/cm_job_${tag}.sh
	chmod +x ${main_path}/job_${tag}.sh
	chmod +x ${main_path}/cm_job_${tag}.sh

done
