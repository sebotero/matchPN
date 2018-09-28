/*******************************************************************************
AUTHOR: Sebastian Otero
CREATION: 13-Sept-2018
ACTION: creates data to be matched to cedula
********************************************************************************/

set more off 
clear all

******************************************************************************** 
** SET PATH AND LOCALS
******************************************************************************** 

cd "/Volumes/sebastian/Research/DR/1_Data/Instituciones/PN/"

******************************************************************************** 
** 1. CLEAN NON-DICOTOMIZADA
******************************************************************************** 

/*
Observations:
- Run for years in which we don't have names and last names in the dicotomized 
  data
- For now you should run for 2006-2009 and 2010-2015
- Drop modalidades ARTES and ACADEMICOS, and keep all others
- Input: is source data imported from an excel sheet
- Output: is a dta data with unique observations for each individual
*/
/*
forv x=2010/2015{

use "src/`x'/PN_`x'.dta", clear

* Rename variables

renvars, lower

destring centrodepecodigo, replace

foreach var in esp mat nat soc{
cap: ren pres_`var' presentacion_`var'
cap: ren resp_`var' prueba_`var'
cap: ren fina_`var' final_`var'
cap: ren presentaciñn_`var' presentacion_`var'
cap: ren presentacin_`var' presentacion_`var'
cap: ren presentaciãn_`var' presentacion_`var'
}

* Clean variables

foreach var in codigo_rne nombres apellido1 apellido2 sexo nombre_modalidad nombre_modalidad nombre_especialidad{
replace `var'=trim(itrim(`var'))
}

* Drop academicos & artes

drop if inlist(nombre_modalidad,"ACADEMICOS", "ARTES")

* Keep useful variables

keep idestudiante codigo_rne nombres apellido1 apellido2 nombre_modalidad sexo centrodepecodigo presentacion_* convocatoria

* Drop duplicates with similar characteristics (varying only in convocatoria)

gen codigo_rne_short=substr(codigo_rne,1,9)

duplicates drop centrodepecodigo nombre_modalidad codigo_rne_short idestudiante nombres apellido1 apellido2 sexo presentacion_esp presentacion_mat presentacion_soc presentacion_nat, force

* Replace idestudiante missing, for students with same initials, bday and school

replace idestudiante=0 if idestudiante==.

bys codigo_rne_short centrodepecodigo: egen aa=max(idestudiante)

replace idestudiante=aa if idestudiante==0

* Flag individuals with different notas presentación

duplicates tag   centrodepecodigo nombre_modalidad codigo_rne_short idestudiante nombres apellido1 apellido2 sexo, gen(dup)

gen flag1=(dup>0)

lab var flag1 "1=individual has different notas de presentacion"

drop dup

sort codigo_rne convocatoria

duplicates drop  centrodepecodigo nombre_modalidad codigo_rne_short idestudiante nombres apellido1 apellido2 sexo, force

* Assert that there are no repeated individuals by codigo_rne

duplicates tag codigo_rne, gen(dup)

assert dup==0

duplicates drop codigo_rne, force

* Replace missing idestudiantes and keep relevant variables

replace idestudiante=0 if idestudiante==.

keep codigo_rne idestudiante nombres apellido1 apellido2 sexo centrodepecodigo nombre_modalidad presentacion_*

save "src/`x'/PN_`x'_uniqueNames.dta", replace

}
*/
******************************************************************************** 
** 2. CLEAN DICOTOMIZADA
******************************************************************************** 
/*
/*
Observations:
- Run for all years 
- Drop modalidades ARTES and ACADEMICOS, and keep all others
- Input: is source data imported from SPSS file
- Output: is a dta data with unique observations for each individual
*/

forv x=2010/2013{

use "src/`x'/PN_`x'_answers.dta", clear

* Rename variables

renvars, lower

cap: ren codigo_centro centrodepecodigo
cap: ren id_estudiante idestudiante

foreach var in esp mat nat soc{
cap: ren pres_`var' presentacion_`var'
cap: ren resp_`var' prueba_`var'
cap: ren fina_`var' final_`var'
cap: ren presentaciñn_`var' presentacion_`var'
cap: ren presentacin_`var' presentacion_`var'
cap: ren presentaciãn_`var' presentacion_`var'
}

destring centrodepecodigo, replace

* Create variable with initials and bday

gen codigo_rne_short=substr(codigo_rne,1,9)

* Clean variables

foreach var in codigo_rne nombre_completo nombres apellido1 apellido2 sexo nombre_modalidad nombre_modalidad nombre_especialidad{
cap: replace `var'=trim(itrim(`var'))
}

replace idestudiante=0 if idestudiante==.

replace nombre_completo=" " if nombre_completo==""

* Drop academicos & artes

drop if inlist(nombre_modalidad,"ACADEMICOS", "ARTES")

tab nombre_modalidad 

// should have: ADULTOS FORMAL, BASICA, MODALIDAD GENERAL, TECNICO PROFESIONAL 

* Keep useful variables

keep codigo_rne* idestudiante nombre_completo sexo centrodepecodigo nombre_modalidad presentacion_* convocatoria periodo

* Replace idestudiante missing, for students with same initials, bday and school

bys codigo_rne_short centrodepecodigo: egen aa=max(idestudiante)

replace idestudiante=aa if idestudiante==0

drop aa

* Drop duplicates in everything

duplicates drop codigo_rne idestudiante nombre_completo sexo centrodepecodigo nombre_modalidad presentacion_esp presentacion_mat presentacion_soc presentacion_nat, force

* Gen ID drop duplicates in gender, initials, bday, modalidad and notas presentacion

tostring periodo presentacion*, replace

gen id=periodo+"_"+sexo+"_"+codigo_rne_short+"_"+presentacion_esp+"_"+presentacion_mat+"_"+presentacion_soc+"_"+presentacion_nat

duplicates tag id, gen(dup1)

gen flag_1=(dup1>1)

lab var flag_1 "1=individual was duplicate in id dimension"

tab dup

drop dup

gsort id convocatoria -idestudiante

duplicates drop id, force

destring presentacion_*, replace

* Flag and drop individuals with same names, gender, bday, sechool and modalidad but different notas presentacion

duplicates tag idestudiante nombre_completo sexo codigo_rne_short centrodepecodigo , gen(dup)

gen flag_2=(dup>0)

drop dup

lab var flag_2 "1=individual was duplicate in ID3 dimension, but has different notas de presentacion"

sort codigo_rne convocatoria

duplicates drop idestudiante nombre_completo sexo codigo_rne_short centrodepecodigo, force

* No repeated individuals by codigo_rne

duplicates tag codigo_rne, gen(dup)

assert dup==0

drop dup

duplicates drop codigo_rne, force

* Keep relevant variables

keep codigo_rne nombre_completo sexo centrodepecodigo nombre_modalidad idestudiante presentacion_* id flag*

* Dummy indicating variable is from the answer dataset 

gen answer=1

lab var answer "Variable is from the answer dataset"

save "src/`x'/PN_`x'_answers_ID.dta", replace

}
*/
******************************************************************************** 
** 3. CREATE CROSSWALK BETWEEN DICOTOMIZADA & NO DICOTOMIZADA
******************************************************************************** 
/*
/*
Observations:
- Run for years in which we don't have names and last names in the dicotomized 
  data
- Input: Unique Names 
- Output: is a dta data with unique observations for each individual
*/

forv x=2010/2013{

use "src/`x'/PN_`x'_uniqueNames.dta", clear

merge 1:1 codigo_rne using "src/`x'/PN_`x'_answers_ID.dta"

* Now we deal with the non-merged observations

preserve

keep if _merge!=3

* Flag observations that didn't match 1:1 using codigo_rne

gen flag_3=1

lab var flag_3 "1=observation has different codigo_rne across names and no names datasets"

replace idestudiante=0 if idestudiante==.

* We merge these observations matching with their idestudiante, school, notas de presentación and gender

egen group=group(idestudiante centrodepecodigo sexo presentacion_esp presentacion_mat presentacion_soc presentacion_nat) 

* Keep only those that have a match

bys group: gen N=_N

keep if N==2

* Drop those that have a match in the same database

bys group: egen suma=sum(answer)

drop if suma==0

* Keep the Answers dataset codigo_rne

gen codigo_rne_answers="" 				if answer==1
replace codigo_rne_answer=codigo_rne 	if answer==1

* Complete Names and Last Names

spread codigo_rne_answer nombres apellido1 apellido2 id flag_*, by(group)

keep nombres apellido* codigo_rne_answers flag_*

ren codigo_rne_answer codigo_rne

* Drop duplicate observations (mechanicaly, half of it)

duplicates drop

tempfile temp`x'
save `temp`x''

restore

* Merge to the rest of the data

keep if _merge==3
append using `temp`x''

keep nombres apellido* codigo_rne flag_* id

replace flag_3=0 if flag_3==.

save "src/`x'/PN_`x'_crosswalk.dta", replace  

*rm "src/`x'/PN_`x'_uniqueNames.dta"

}
*/
******************************************************************************** 
** CLEAN DICOTOMIZED DATASET
******************************************************************************** 

forv x=2010/2013{

use "src/`x'/PN_`x'_answers.dta", clear

* Rename variables

renvars, lower

cap: ren regional_codigo  	regional
cap: ren distrito_codigo  	distrito
cap: ren codigo_centro 		centrodepecodigo
cap: ren nombre_centro 		centrodepenombre
cap: ren id_estudiante 		idestudiante

destring distrito, replace
destring regional, replace
destring centrodepecodigo, replace

foreach var in esp mat nat soc{
cap: ren pres_`var' presentacion_`var'
cap: ren resp_`var' prueba_`var'
cap: ren fina_`var' final_`var'
cap: ren presentaciñn_`var' presentacion_`var'
cap: ren presentacin_`var' presentacion_`var'
cap: ren presentaciãn_`var' presentacion_`var'
}

cap: ren condicion_final condicion

* Clean variables

foreach var in codigo_rne nombre_completo nombres apellido1 apellido2 sexo nombre_modalidad nombre_modalidad nombre_especialidad{
cap: replace `var'=trim(itrim(`var'))
}

replace idestudiante=0 if idestudiante==.

* Create variable with initials and bday

gen codigo_rne_short=substr(codigo_rne,1,9)

* Drop academicos & artes

drop if inlist(nombre_modalidad,"ACADEMICOS", "ARTES")

tab nombre_modalidad 

// should have: ADULTOS FORMAL, BASICA, MODALIDAD GENERAL, TECNICO PROFESIONAL 


* Replace idestudiante missing, for students with same initials, bday and school

bys codigo_rne_short centrodepecodigo: egen aa=max(idestudiante)

replace idestudiante=aa if idestudiante==0

drop aa

* Gen ID drop duplicates in gender, initials, bday, modalidad and notas presentacion

tostring periodo presentacion*, replace

gen id=periodo+"_"+sexo+"_"+codigo_rne_short+"_"+presentacion_esp+"_"+presentacion_mat+"_"+presentacion_soc+"_"+presentacion_nat

destring presentacion_*, replace

* Merge to our unique ID database

merge n:1 id using "src/`x'/PN_`x'_answers_ID.dta"

drop if _merge==1

assert _merge!=2

drop _merge

* Merge names

if `x'>2005 & `x'<2016{

merge n:1 codigo_rne using "src/`x'/PN_`x'_crosswalk.dta"  

drop if _merge==2

drop _merge

}

* Replace idestudiantes

*destring p1-p70, replace

save  "dta/cleaned/`x'/PN`x'_answers.dta", replace

tab nombre_modalidad, m
}

