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
** FIX NAMES AND RETRIEVE DATES
******************************************************************************** 

forv x=2010/2013{

use "dta/cleaned/`x'/PN`x'_answers.dta", clear

global vars nombres apellido1 apellido2 

keep $vars edad idestudiante periodo sexo codigo_rne nombre_completo centrodepecodigo centrodepenombre tanda convocatoria sector distrito regional presentacion* id flag*

* Clean variables

foreach var in $vars sexo codigo_rne centrodepenombre{
	replace `var' = trim(itrim(`var'))
}

* Check Duplicates

duplicates drop codigo_rne, force

gen codigo_rne_old=codigo_rne

replace codigo_rne=subinstr(codigo_rne,"Á","A",.)
replace codigo_rne=subinstr(codigo_rne,"Ä","A",.)
replace codigo_rne=subinstr(codigo_rne,"É","E",.)
replace codigo_rne=subinstr(codigo_rne,"Í","I",.)
replace codigo_rne=subinstr(codigo_rne,"Ó","O",.)
replace codigo_rne=subinstr(codigo_rne,"Ú","U",.)
replace codigo_rne=subinstr(codigo_rne,"À","A",.)
replace codigo_rne=subinstr(codigo_rne,"È","E",.)
replace codigo_rne=subinstr(codigo_rne,"Ì","I",.)
replace codigo_rne=subinstr(codigo_rne,"Ò","O",.)
replace codigo_rne=subinstr(codigo_rne,"Ù","U",.)
replace codigo_rne=subinstr(codigo_rne,"Ü","U",.)
replace codigo_rne=subinstr(codigo_rne,"Ñ","N",.)
replace codigo_rne=subinstr(codigo_rne,"Ý","Y",.)
replace codigo_rne=subinstr(codigo_rne,"ç","c",.)
replace codigo_rne=subinstr(codigo_rne,"Ç","C",.)

******************************************************************************** 
** FIX CODES
******************************************************************************** 

//	2000

replace codigo_rne="AV-8604270000" if codigo_rne=="AV-2704860000"
replace codigo_rne="CCC8603210000" if codigo_rne=="CCC2103860000"
replace codigo_rne="DVC7712300000" if codigo_rne=="DVC1230770000"
replace codigo_rne="ABP7926020001" if codigo_rne=="ABP2602790001"
replace codigo_rne="JCA8407070000" if codigo_rne=="JCA0707840000"
replace codigo_rne="CBN8708080000" if codigo_rne=="CBN0808870000"
replace codigo_rne="DGF7908150000" if codigo_rne=="DGF7915080000"
replace codigo_rne="GHF7901210000" if codigo_rne=="GHF7921010000"
replace codigo_rne="AEP8506270000" if codigo_rne=="AEP8527060000" 
replace codigo_rne="ABP7902260001" if codigo_rne=="ABP7926020001"

// 2002
replace codigo_rne="RRO8905160000" if codigo_rne=="´RO8905160000"
replace codigo_rne="MMP8701210000" if codigo_rne=="M´P8701210000"

// 2003
replace codigo_rne="SMC7906110001" if codigo_rne=="SMº7906110001"

// 2004
replace codigo_rne="JOP7003250001" if codigo_rne=="JO´7003250001"
replace codigo_rne="LCP9105180001" if codigo_rne=="LC´9105180001"
replace apellido2="" 			   if codigo_rne=="AH-8908010001"
replace codigo_rne="SC-4805190001" if codigo_rne=="SC´4805190001"

// 2005
replace codigo_rne="KPC9103160001" if codigo_rne=="K´C9103160001"
replace codigo_rne="CHP8603110001" if codigo_rne=="CH´8603110001"

// 2014

replace nombres="LUHISAURY" 							if idestudiante==1467043
replace apellido1="NANE" 								if idestudiante==1467043
replace apellido2="FAMILIA" 							if idestudiante==1467043
replace codigo_rne="LNF9401250001" 						if idestudiante==1467043
replace nombre_completo="LUHISAURY NANE FAMILIA" 		if idestudiante==1467043

replace nombres="ROSANNA MERCEDES" 						if idestudiante==5521145
replace apellido1="NUNEZ" 								if idestudiante==5521145
replace apellido2="MUNOZ" 								if idestudiante==5521145
replace codigo_rne="RNM8801120001" 						if idestudiante==5521145
replace nombre_completo="ROSANNA MERCEDES NUNEZ MUNOZ" 	if idestudiante==5521145

replace nombres="VICTOR"	 							if idestudiante==5201498
replace apellido1="NANEZ" 								if idestudiante==5201498
replace apellido2="MORENO" 								if idestudiante==5201498
replace codigo_rne="VNM7807200001" 						if idestudiante==5201498
replace nombre_completo="VICTOR_NANEZ MORENO" 			if idestudiante==5201498

replace nombres="NADILSON" 								if idestudiante==1811166
replace apellido1="PEGUERO" 							if idestudiante==1811166
replace apellido2="GENAO" 								if idestudiante==1811166
replace codigo_rne="NPG9811070001" 						if idestudiante==1811166
replace nombre_completo="NADILSON PEGUERO GENAO" 		if idestudiante==1811166

// 2015
replace nombres="FRANCISCA" 		if idestudiante==5730006
replace apellido1="NUNEZ" 			if idestudiante==5730006
replace apellido2="ALMANZAR" 		if idestudiante==5730006
replace codigo_rne="FNA6701290001" 	if idestudiante==5730006

replace nombres="MANUEL DE JESUS" 	if idestudiante==1676428
replace apellido1="YANEZ" 			if idestudiante==1676428
replace apellido2="CONCEPCION" 		if idestudiante==1676428
replace codigo_rne="MYC9611210001" 	if idestudiante==1676428

replace nombres="OLIVER" 			if idestudiante==5673142
replace apellido1="MORILLO" 		if idestudiante==5673142
replace apellido2="DE OLEO" 		if idestudiante==5673142
replace codigo_rne="OMD9508070001" 	if idestudiante==5673142

replace nombres="RANDI EMILIO" 		if idestudiante==1944211
replace apellido1="ZAPATA" 		  	if idestudiante==1944211
replace apellido2="COLON"	 	   	if idestudiante==1944211
replace codigo_rne="RZC9601290001"  if idestudiante==1944211

replace nombres="RAMONA VIANCA" 	if idestudiante==4114538
replace apellido1="NANEZ " 		  	if idestudiante==4114538
replace apellido2="SANTO"	 	   	if idestudiante==4114538
replace codigo_rne="RNS0107130001"  if idestudiante==4114538

replace nombres="ERICA" 			if idestudiante==2846787
replace apellido1="BAPTISTE" 	  	if idestudiante==2846787
replace apellido2="MARCEL"	 	   	if idestudiante==2846787
replace codigo_rne="EBM9907230001"  if idestudiante==2846787

// 2016

replace codigo_rne="GPP9910300001" 	if idestudiante==2806606

// 2017

******************************************************************************** 
** FIX DATES
******************************************************************************** 

gen yy=substr(codigo_rne,4,2)
gen mm=substr(codigo_rne,6,2)
gen dd=substr(codigo_rne,8,2)

destring yy mm dd, replace

replace yy=yy+1900 if yy>20
replace yy=yy+2000 if yy<=20

gen date=mdy(mm,dd,yy)
gen date1=date
format date1 %td

bys edad: egen date_mode=mode(date)

gen dd_mode=day(date_mode)
gen mm_mode=month(date_mode)
gen yy_mode=year(date_mode)

replace dd=dd_mode if date==. & date_mode!=.
replace mm=mm_mode if date==. & date_mode!=.
replace yy=yy_mode if date==. & date_mode!=.

tab dd
tab mm
tab yy

destring periodo, replace

gen edad_year=periodo-yy
replace yy=. if edad_year>50 | edad_year<8
replace yy=. if mm==0

replace dd=. if dd>31 | dd<1
replace mm=. if mm>12 | mm<1

drop edad_year *_mode date*

******************************************************************************** 
** FIX NAMES
******************************************************************************** 

foreach nom in $vars nombre_completo{
replace `nom'=subinstr(`nom',"(HIJO)","",.)
replace `nom'=subinstr(`nom',"(DE)","",.)
replace `nom'=subinstr(`nom',"( JUNIOR )","",.)
replace `nom'=subinstr(`nom',"(DEL)","",.)
replace `nom'=subinstr(`nom',"(TOMMY)","",.)
replace `nom'=subinstr(`nom',"PE?A","PENA",.)
replace `nom'=subinstr(`nom',"NU?EZ","NUNEZ",.)
replace `nom'=subinstr(`nom',"CALCA?O","CALCANO",.)
replace `nom'=subinstr(`nom',"ALMANZARÇ","ALMANZAR",.)
replace `nom'=subinstr(`nom',"Á","A",.)
replace `nom'=subinstr(`nom',"Ä","A",.)
replace `nom'=subinstr(`nom',"É","E",.)
replace `nom'=subinstr(`nom',"Í","I",.)
replace `nom'=subinstr(`nom',"Ó","O",.)
replace `nom'=subinstr(`nom',"Ú","U",.)
replace `nom'=subinstr(`nom',"À","A",.)
replace `nom'=subinstr(`nom',"È","E",.)
replace `nom'=subinstr(`nom',"Ì","I",.)
replace `nom'=subinstr(`nom',"Ò","O",.)
replace `nom'=subinstr(`nom',"Ù","U",.)
replace `nom'=subinstr(`nom',"Ä","A",.)
replace `nom'=subinstr(`nom',"Ë","E",.)
replace `nom'=subinstr(`nom',"Ï","I",.)
replace `nom'=subinstr(`nom',"Ö","O",.)
replace `nom'=subinstr(`nom',"Ü","U",.)
replace `nom'=subinstr(`nom',"Ñ","N",.)
replace `nom'=subinstr(`nom',"Ø","O",.)
replace `nom'=subinstr(`nom',"Ý","Y",.)
replace `nom'=subinstr(`nom',"á","a",.)
replace `nom'=subinstr(`nom',"é","e",.)
replace `nom'=subinstr(`nom',"í","i",.)
replace `nom'=subinstr(`nom',"ó","o",.)
replace `nom'=subinstr(`nom',"ú","u",.)
replace `nom'=subinstr(`nom',"à","a",.)
replace `nom'=subinstr(`nom',"ä","a",.)
replace `nom'=subinstr(`nom',"è","e",.)
replace `nom'=subinstr(`nom',"ì","i",.)
replace `nom'=subinstr(`nom',"ò","o",.)
replace `nom'=subinstr(`nom',"ù","u",.)
replace `nom'=subinstr(`nom',"ü","u",.)
replace `nom'=subinstr(`nom',"ñ","n",.)
replace `nom'=subinstr(`nom',"0","O",.)
replace `nom'=subinstr(`nom',"ç","c",.)
replace `nom'=subinstr(`nom',"Ç","C",.)
replace `nom'=subinstr(`nom',"."," ",.)
replace `nom'=subinstr(`nom',"º","",.)
replace `nom'=subinstr(`nom',"*","",.)
replace `nom'=subinstr(`nom',"-"," ",.)
replace `nom'=subinstr(`nom',"_","",.)
replace `nom'=subinstr(`nom',","," ",.)
replace `nom'=subinstr(`nom',"=","",.)
replace `nom'=subinstr(`nom',"¨¨","",.)
replace `nom'=subinstr(`nom',"<"," ",.)
replace `nom'=subinstr(`nom',";"," ",.)
replace `nom'=subinstr(`nom',"´"," ",.)
replace `nom'=subinstr(`nom',"'"," ",.)
replace `nom'=subinstr(`nom',"`"," ",.)
replace `nom'=subinstr(`nom',"+","",.)
replace `nom'=subinstr(`nom',"^","",.)
replace `nom'=subinstr(`nom',"°","",.)
replace `nom'=subinstr(`nom',"~","",.)
replace `nom'=subinstr(`nom',"/","",.)
replace `nom'=subinstr(`nom',"\","",.)
replace `nom'=subinstr(`nom',"{","",.)
replace `nom'=subinstr(`nom',"}","",.)
replace `nom'=subinstr(`nom',"]","",.)
replace `nom'=subinstr(`nom',")","",.)
replace `nom'=subinstr(`nom',"(","",.)
replace `nom'=subinstr(`nom',"[","",.)
replace `nom'=subinstr(`nom',"?","",.)
replace `nom'=subinstr(`nom',"|"," ",.)
replace `nom'=subinstr(`nom',"¡"," ",.)
replace `nom'=subinstr(`nom',`"""'," ",.)
forv num = 1/9 {
	replace `nom'=subinstr(`nom',"`num'"," ",.)
}
replace `nom'=trim(itrim(`nom'))
}

egen a1=sieve(nombres)			, keep(alphabetic spaces)
egen a2=sieve(apellido1)		, keep(alphabetic spaces)
egen a3=sieve(apellido2)		, keep(alphabetic spaces)
egen a4=sieve(nombre_completo)	, keep(alphabetic spaces)

assert a1==nombres 
assert a2==apellido1
assert a3==apellido2

* Gen nombre completo from names and last names

gen aa=nombres+" "+apellido1+" "+apellido2
replace aa=trim(itrim(aa))

* Replace nombre completo if nombre completo is missing

replace nombre_completo=aa if  nombre_completo=="" 

replace nombre_completo=trim(itrim(nombre_completo))

* Also replace nombre completo if nombre completo has weird characters and aa is not missing

replace nombre_completo=aa if (nombre_completo!=a4 & aa!="")

replace nombre_completo=trim(itrim(nombre_completo))

* Replace nombre completo for the sieve version if the new nombre completo is missing

replace nombre_completo=a4 if nombre_completo==""

* Correct the few cases

egen a5=sieve(nombre_completo)	, keep(alphabetic spaces)

replace nombre_completo=a5 if nombre_completo!=a5

assert a5==nombre_completo

drop a1 a2 a3 a4 a5 aa

* Create

******************************************************************************** 
** CHECK DUPLICATES
******************************************************************************** 

* Duplicates 1

duplicates drop nombre_completo nombres apellido1 apellido2 sexo yy mm dd centrodepecodigo presentacion_esp presentacion_mat presentacion_soc presentacion_nat, force

duplicates drop 				nombres apellido1 apellido2 sexo yy mm dd centrodepecodigo presentacion_esp presentacion_mat presentacion_soc presentacion_nat, force

* Duplicates 2

duplicates tag nombre_completo nombres apellido1 apellido2 sexo yy mm dd centrodepenombre, gen(dup)

gen flag_4=(dup>0)

lab var flag_4 "1=individual was duplicate"

tab dup

drop dup

duplicates drop nombre_completo nombres apellido1 apellido2 sexo yy mm dd centrodepenombre, force

* Duplicates 3

duplicates tag nombres apellido1 apellido2 sexo yy mm dd, gen(dup)

gen flag_5=(dup>0)

lab var flag_5 "1=individual was duplicate"

tab dup

drop dup

duplicates drop nombres apellido1 apellido2 sexo yy mm dd, force

* Duplicates 4

duplicates tag id, gen(dup)

gen flag_6=(dup>0)

lab var flag_6 "1=individual was duplicate"

tab dup

drop dup

duplicates drop id,  force

sort codigo_rne_old

* Flag duplicatees

replace flag_1=1 if  flag_4==1 | flag_5==1  | flag_6==1

drop flag_4 flag_5 flag_6

* Keep some relevant variables

keep  periodo codigo_rne_old nombre_completo nombres apellido1 apellido2 sexo yy mm dd flag* id
order periodo codigo_rne_old nombre_completo nombres apellido1 apellido2 sexo yy mm dd flag* id

duplicates drop codigo_rne , force

ren yy anoNac
ren mm mesNac
ren dd diaNac
ren nombre_completo nombrecompleto
ren codigo_rne_old codigo_rne

keep id codigo_rne nombrecompleto nombres apellido1 apellido2 anoNac mesNac diaNac 

export delimited using "$path/dta/toMatch/`x'/PN`x'_toMatch.txt", replace

save "$path/dta/toMatch/`x'/PN`x'_toMatch", replace

}






































