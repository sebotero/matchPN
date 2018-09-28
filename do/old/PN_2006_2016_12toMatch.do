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

forv y=2006/2016{

if `y'<2010{
use "src/PN_`y'.dta", clear
}

if `y'>=2010{
use "src/PN`y'.dta", clear
}

** KEEP 12

foreach var in nombre_especialidad nombre_modalidad nombres apellido1 apellido2{
replace `var'=trim(itrim(`var'))
}

keep if nombre_modalidad=="TECNICO PROFESIONAL" | nombre_modalidad=="MODALIDAD GENERAL"

cap: gen idestudiante=.

keep nombres apellido1 apellido2 sexo edad codigo_rne idestudiante

duplicates drop

sort nombres apellido* 


** GEN BDAY

*2010
replace codigo_rne="JAG9208110001" 	if codigo_rne=="JG9208110001"
replace codigo_rne="ASA8910020001" 	if codigo_rne=="AS8910020001" 
replace codigo_rne="EFG9101090001"  if codigo_rne=="ÛFG9101090001"
replace codigo_rne="ADR9001100001" 	if codigo_rne=="DR9001100001"
replace codigo_rne="MAA9303100001" 	if codigo_rne=="M9303100001" 
replace codigo_rne="MMA9204040001" 	if codigo_rne=="MM9204040001" 
replace codigo_rne="PAR9208290001" 	if codigo_rne=="PR9208290001"
replace codigo_rne="RAA9010150001" 	if codigo_rne=="R9010150001"
replace codigo_rne="MA-8701200001" 	if codigo_rne=="M-8701200001"

*2011
replace codigo_rne="ARF9403050001" if codigo_rne=="RF9403050001"
replace codigo_rne="RGA9302010001" if codigo_rne=="RG9302010001"
replace codigo_rne="CCA9303120001" if codigo_rne=="CC9303120001"
replace codigo_rne="ASA8910020001"  if codigo_rne=="ASè8910020001"
replace codigo_rne="RA-9004090001" if  codigo_rne=="R-9004090001"

*2012
replace codigo_rne="GAP9511200001" if codigo_rne=="GP9511200001"
replace codigo_rne="SAN9408130001" if codigo_rne=="SN9408130001"
replace codigo_rne="CBA9404130001" if codigo_rne=="CB9404130001"
replace codigo_rne="MRA9508290001" if codigo_rne=="MR9508290001"
replace codigo_rne="LVA9504050001" if codigo_rne=="LV9504050001"
replace codigo_rne="YAC9511170001" if codigo_rne=="YC9511170001"
replace codigo_rne="AR-7804160001" if codigo_rne=="R-7804160001"

*2013
replace codigo_rne="PRA9604290001" if  codigo_rne=="PR9604290001"
replace codigo_rne="AAP9603080001" if  codigo_rne=="AP9603080001"
replace codigo_rne="ACE9503160001" if  codigo_rne=="ÄCE9503160001"
replace codigo_rne="ABS9408030001" if  codigo_rne=="BS9408030001"
replace codigo_rne="YPA9403310001" if  codigo_rne=="YP9403310001"

*2014
replace codigo_rne="ALC9408120001" if codigo_rne=="LC9408120001"
replace codigo_rne="CAC9608290001" if codigo_rne=="CC9608290001"
replace codigo_rne="VAS9612130001" if codigo_rne=="VS9612130001"
replace codigo_rne="RZE9601290001" if codigo_rne=="RZâ9601290001"
replace codigo_rne="AC-5910270001" if codigo_rne=="AÇ-5910270001"

*2015
replace codigo_rne="OMD9508070001" 	if codigo_rne=="OMÂ9508070001"
replace codigo_rne="CGC6809260001" 	if codigo_rne=="CGÇ6809260001"
replace codigo_rne="JDA9710310001" if codigo_rne=="JD9710310001"
replace codigo_rne="KAE9707200001" if codigo_rne=="KE9707200001"
replace codigo_rne="AMP9704020001" if codigo_rne=="MP9704020001"
replace codigo_rne="ANR9704110001" if codigo_rne=="NR9704110001"
replace codigo_rne="AG-9709040001" if codigo_rne=="G-9709040001"

*2016
replace codigo_rne="ANC9809300001" if codigo_rne=="AÑC9809300001"
replace codigo_rne="LND9401100001" if codigo_rne=="LÑD9401100001"
replace codigo_rne="YGP9910300001"   if codigo_rne==" GP9910300001"
replace codigo_rne="GNF9805270001" 	 if codigo_rne=="¨NF9805270001"

gen yy=substr(codigo_rne,4,2)
gen mm=substr(codigo_rne,6,2)
gen dd=substr(codigo_rne,8,2)

if `y'>=2010 & `y'<2016 {

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

replace yy=1900 + yy if yy>19
replace yy=2000 + yy if yy<19

replace yy=1989 if codigo_rne=="NMS0089122500"
replace mm=12   if codigo_rne=="NMS0089122500"
replace dd=25   if codigo_rne=="NMS0089122500"

gen period=`y'
tempfile temp`y'
save `temp`y''
}

** APPEND

use `temp2006', clear
forv x=2007/2016{
append using `temp`x''
}

drop edad 

sort codigo_rne  period  nombres apellido1 apellido2 sexo yy mm dd

foreach var in nombres apellido1 apellido2{
replace `var'=upper(`var')
replace `var'=trim(itrim(`var'))
replace `var'=subinstr(`var', "Ñ", "N",.)
replace `var'=subinstr(`var', "Á", "A",.)
replace `var'=subinstr(`var', "É", "E",.)
replace `var'=subinstr(`var', "Í", "I",.)
replace `var'=subinstr(`var', "Ó", "O",.)
replace `var'=subinstr(`var', "Ú", "U",.)
replace `var'=subinstr(`var', "-", " ",.)
replace `var'=subinstr(`var', ".", "",.)
replace `var'=subinstr(`var', ",", "",.)
replace `var'=trim(itrim(`var'))
}

drop if codigo_rne==""

save  "dta/PN_2006_2016_12toMatch.dta", replace


