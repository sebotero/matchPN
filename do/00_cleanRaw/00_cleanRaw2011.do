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

global path "/Volumes/sebastian/Research/DR/1_Data/Instituciones/PN/"

******************************************************************************** 
** CLEAN 2011
******************************************************************************** 

use "src/2011/toClean/PN_2011_toClean.dta", clear

renvars, lower

ren presentacin_esp presentacion_esp
ren presentacin_mat presentacion_mat
ren presentacin_soc presentacion_soc
ren presentacin_nat presentacion_nat
ren seccin seccion

global vars nombres apellido1 apellido2

foreach nom in $vars{
replace `nom'=subinstr(`nom',"(HIJO)","",.)
replace `nom'=subinstr(`nom',"(JR)","",.)
replace `nom'=subinstr(`nom',"ƒ","E",.)
replace `nom'=subinstr(`nom',"î","O",.)
replace `nom'=subinstr(`nom',"'","",.)
replace `nom'=subinstr(`nom',"`","",.)
replace `nom'=subinstr(`nom',"é","E",.)
replace `nom'=subinstr(`nom',"í","I",.)
replace `nom'=subinstr(`nom',"ê","I",.)
replace `nom'=subinstr(`nom',"ç","A",.)
replace `nom'=subinstr(`nom',"Ë","A",.)
replace `nom'=subinstr(`nom',"_","",.)
replace `nom'=subinstr(`nom',"ò","U",.)
replace `nom'=subinstr(`nom',"0","O",.)
replace `nom'=subinstr(`nom',"ñ","O",.)
replace `nom'=subinstr(`nom',"†","U",.)
replace `nom'=subinstr(`nom',"ô","U",.)
replace `nom'=subinstr(`nom',"PE;A","PENA",.)
replace `nom'=subinstr(`nom',"(KELLY)","",.)
replace `nom'=subinstr(`nom',"(ALBERTO)","",.)
replace `nom'=subinstr(`nom',".","",.)
replace `nom'=subinstr(`nom',"ÌÔ","N",.)
replace `nom'=subinstr(`nom',"ï","O",.)
replace `nom'=subinstr(`nom',"Ê","",.)
replace `nom'=subinstr(`nom',"D«ALIZA","D ALIZA",.)
replace `nom'=subinstr(`nom',"D«OLEO","D OLEO",.)
replace `nom'=subinstr(`nom',"D« OLMO","D OLEO",.)
replace `nom'=subinstr(`nom',"D« ALISA","D ALISA",.)
replace `nom'=subinstr(`nom',"«"," ",.)
replace `nom'=subinstr(`nom',"+","",.)
replace `nom'=subinstr(`nom',";","",.)
replace `nom'=subinstr(`nom',"<","",.)
replace `nom'=subinstr(`nom',`"""'," ",.)
replace `nom'=subinstr(`nom',","," ",.)
replace `nom'=subinstr(`nom',"‚"," ",.)
replace `nom'=subinstr(`nom',"-","",.)
replace `nom'=subinstr(`nom',"|","",.)
replace `nom'=subinstr(`nom',"/","",.)
replace `nom'=subinstr(`nom',"¬"," ",.)
replace `nom'=subinstr(`nom',"*","",.)
forv num = 1/9 {
	replace `nom'=subinstr(`nom',"`num'"," ",.)
}
replace `nom'=trim(itrim(`nom'))

}

replace apellido2="" if codigo_rne=="YR-8406140001"

egen a1=sieve(nombres)  , keep(alphabetic spaces)
egen a2=sieve(apellido1), keep(alphabetic spaces)
egen a3=sieve(apellido2), keep(alphabetic spaces)

br nombres apellido* if a1!=nombres | a2!=apellido1 | a3!=apellido2

assert a1==nombres
assert a2==apellido1
assert a3==apellido2

drop a1 a2 a3

save "${path}/src/2011/PN_2011.dta", replace
