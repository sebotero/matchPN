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

** LOAD DATA

forv y=2006/2015{

if `y'<2010{
use "src/PN_`y'.dta", clear
}

if `y'>=2010{
use "src/PN`y'.dta", clear
}

** KEEP 12

foreach var in nombre_especialidad nombre_modalidad{
replace `var'=trim(itrim(`var'))
}

replace nombre_modalidad="BASICA" if nombre_modalidad=="BÁSICA"

keep if nombre_modalidad=="BASICA" 

keep nombres apellido1 apellido2 sexo edad codigo_rne

drop if codigo_rne=="#NAME?" | codigo_rne==""

** GEN BDAY

gen yy=substr(codigo_rne,4,2)
gen mm=substr(codigo_rne,6,2)
gen dd=substr(codigo_rne,8,2)

if `y'==2010 {

egen bday=sieve(codigo_rne) if strpos(codigo_rne,"CLP")>0, keep(numeric)
gen yy1=substr(bday,1,2)
gen mm1=substr(bday,3,2)
gen dd1=substr(bday,5,2)

replace yy=yy1 if strpos(codigo_rne,"CLP")>0 
replace mm=mm1 if strpos(codigo_rne,"CLP")>0 
replace dd=dd1 if strpos(codigo_rne,"CLP")>0 

drop yy1 mm1 dd1 bday

}

destring yy mm dd, replace

replace yy=1900 + yy if yy>20
replace yy=2000 + yy if yy<20

replace yy=1989 if codigo_rne=="NMS0089122500"
replace mm=12   if codigo_rne=="NMS0089122500"
replace dd=25   if codigo_rne=="NMS0089122500"

replace yy=2000 if codigo_rne=="JF0007250001"
replace mm=7 	if codigo_rne=="JF0007250001"
replace dd=25 	if codigo_rne=="JF0007250001"

replace yy=1995 if codigo_rne=="LRR0095032200"
replace mm=3 	if codigo_rne=="LRR0095032200"
replace dd=22 	if codigo_rne=="LRR0095032200"

gen period=`y'

tempfile temp`y'
save `temp`y''
}

** APPEND

use `temp2006', clear
forv x=2007/2015{
append using `temp`x''
}

drop edad edadPN

sort codigo_rne  period  nombres apellido1 apellido2 sexo yy mm dd

duplicates drop codigo_rne, force
drop if codigo_rne==""

save  "dta/PN_2006_2015_8toMatch.dta", replace


