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
** CLEAN 2010
******************************************************************************** 

use "${path}/src/2010/toClean/PN_2010_toClean.dta", clear

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
replace `nom'=subinstr(`nom',"(MELLIZO)","",.)
replace `nom'=subinstr(`nom',"(MAICOR)","",.)
replace `nom'=subinstr(`nom',"'","",.)
replace `nom'=subinstr(`nom',"`","",.)
replace `nom'=subinstr(`nom',"RAPHAèL","RAPHAEL",.)
replace `nom'=subinstr(`nom',"è","A",.)
replace `nom'=subinstr(`nom',"0","O",.)
replace `nom'=subinstr(`nom',"ê","I",.)
replace `nom'=subinstr(`nom',"€","E",.)
replace `nom'=subinstr(`nom',"Ê","U",.)
replace `nom'=subinstr(`nom',"_","E",.)
replace `nom'=subinstr(`nom',"ª","U",.)
replace `nom'=subinstr(`nom',"÷","U",.)
replace `nom'=subinstr(`nom',"Õ","I",.)
replace `nom'=subinstr(`nom',"ç","A",.)
replace `nom'=subinstr(`nom',"Ó","O",.)
replace `nom'=subinstr(`nom',"JOS_","JOSE",.)
replace `nom'=subinstr(`nom',"RAM_N"," RAMON",.)
replace `nom'=subinstr(`nom',".","",.)
replace `nom'=subinstr(`nom',"+","",.)
replace `nom'=subinstr(`nom',`"""'," ",.)
replace `nom'=subinstr(`nom',","," ",.)
replace `nom'=subinstr(`nom',"‚"," ",.)
replace `nom'=subinstr(`nom',"-","",.)
replace `nom'=subinstr(`nom',"|","",.)
replace `nom'=subinstr(`nom',"/","",.)
replace `nom'=subinstr(`nom',"*","",.)
replace `nom'=subinstr(`nom',"FRAN‰OIS","FRANCOIS",.)
replace `nom'=subinstr(`nom',"DàLIZA","D ALIZA",.)
replace `nom'=subinstr(`nom',"Då","D ",.)
replace `nom'=subinstr(`nom',"DéOLEO","D OLEO",.)
replace `nom'=subinstr(`nom',"KNƒRLE","KNERLE",.)
replace `nom'=subinstr(`nom',"PEÇA","PENA",.)
replace `nom'=subinstr(`nom',"ANA PèTRICIA","ANA PATRICIA",.)
replace `nom'=subinstr(`nom',"DàOLEO","D OLEO",.)
replace `nom'=subinstr(`nom',"URENó","URENA",.)
replace `nom'=subinstr(`nom',"GON‰ALO","GONZALO",.)
replace `nom'=subinstr(`nom',"‰OLON","COLON",.)
replace `nom'=subinstr(`nom',"GÑICHARDO","GUICHARDO",.)
replace `nom'=subinstr(`nom',"LƒFFLER","LAFFLER",.)
replace `nom'=subinstr(`nom',"PI;A","PINA",.)
replace `nom'=subinstr(`nom',"GAR‰ON","GARZON",.)
replace `nom'=subinstr(`nom',"DƒRR","DARR",.)
forv num = 1/9 {
	replace `nom'=subinstr(`nom',"`num'"," ",.)
}
replace `nom'=trim(itrim(`nom'))

}

egen a1=sieve(nombres)  , keep(alphabetic spaces)
egen a2=sieve(apellido1), keep(alphabetic spaces)
egen a3=sieve(apellido2), keep(alphabetic spaces)

assert a1==nombres
assert a2==apellido1
assert a3==apellido2

drop a1 a2 a3


save "${path}/src/2010/PN_2010.dta", replace
