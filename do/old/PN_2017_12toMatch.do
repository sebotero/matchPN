/*******************************************************************************
AUTHOR: Nano Barahona, Sebastian Otero
CREATION: 23-Nov-2017
ACTION: creates data to be matched to cedula
********************************************************************************/

set more off 
clear all

******************************************************************************** 
** SET PATH AND LOCALS
******************************************************************************** 

cd "/Volumes/sebastian/repdom/PN/"

** LOAD DATA 2017

use "src/PN2017_1_2_media.dta", clear

keep nombres apellido* sexo codigo_rne idestudiante nombre_especialidad nombre_modalidad periodo convocatoria

** KEEP 12

foreach var in nombre_especialidad nombre_modalidad{
replace `var'=trim(itrim(`var'))
}

keep if nombre_modalidad=="TECNICO PROFESIONAL" | nombre_modalidad=="MODALIDAD GENERAL"

duplicates drop codigo_rne idestudiante, force

tempfile temp1
save `temp1'

** FIND NAMES IN PREVIOUS DATSETS FOR CONV3

use "src/old/PN2017_DICO_CONV3.dta", clear
renvars, lower

foreach var in nombre_especialidad nombre_modalidad{
replace `var'=trim(itrim(`var'))
}
keep if nombre_modalidad=="TECNICO PROFESIONAL" | nombre_modalidad=="MODALIDAD GENERAL"

duplicates drop codigo_rne, force

preserve
use "dta/PN_2006_2016_12toMatch.dta", clear
duplicates drop codigo_rne, force
tempfile temp2
save `temp2'
restore

merge 1:1 codigo_rne using `temp2', keepusing(nombres apellido1 apellido2)
drop if _merge==2
drop if _merge==1

ren id_estudiante idestudiante
keep nombres apellido* sexo codigo_rne idestudiante nombre_especialidad nombre_modalidad periodo convocatoria nombre_completo

append using `temp1'
sort periodo convocatoria nombres apellido1 apellido2 nombre_completo
duplicates drop codigo_rne, force

** GEN BDAY

replace codigo_rne="AHN0007200001" if codigo_rne=="AHÑ0007200001"
replace codigo_rne="ADB9907310001" if codigo_rne=="ÁDB9907310001"
replace codigo_rne="AEC9204090001" if codigo_rne=="ÁEC9204090001"
replace codigo_rne="JMN9912220002" if codigo_rne=="JMÑ9912220002"
replace codigo_rne="MCA9801090001" if codigo_rne=="MCÁ9801090001"
replace codigo_rne="AFR9911230001" if codigo_rne=="ÁFR9911230001"
replace codigo_rne="ALP9902020001" if codigo_rne=="ÁLP9902020001"
replace codigo_rne="CNH9810300001" if codigo_rne=="CÑH9810300001"

drop if codigo_rne==""

gen yy=substr(codigo_rne,4,2)
gen mm=substr(codigo_rne,6,2)
gen dd=substr(codigo_rne,8,2)

destring yy mm dd, replace 

replace yy=1900 + yy if yy>19
replace yy=2000 + yy if yy<19

gen year=2017

drop if codigo_rne==""

foreach var in nombre_completo nombres apellido1 apellido2{
replace `var'=upper(`var')
replace `var'=trim(itrim(`var'))
replace `var'=subinstr(`var', "Ñ", "N",.)
replace `var'=subinstr(`var', "Á", "A",.)
replace `var'=subinstr(`var', "É", "E",.)
replace `var'=subinstr(`var', "Í", "I",.)
replace `var'=subinstr(`var', "Ó", "O",.)
replace `var'=subinstr(`var', "Ú", "U",.)
replace `var'=subinstr(`var', ".", "",.)
replace `var'=subinstr(`var', ",", "",.)
replace `var'=subinstr(`var', "`", "",.)
replace `var'=subinstr(`var', "´", "",.)
}

save "dta/PN_2017_12toMatch.dta", replace
