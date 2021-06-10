* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* master do file 
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
version 16	

* set options ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set more off
set linesize 255
set logtype text
set varabbrev off 

* clear stuff 
clear all
capture noisily log close _all
macro drop _all

* set globals ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

global root         "~/root/"
global do           "$root/code/Stata"
global out          "$root/output"
global log          "$root/logs"
global temp         "/tmp/"

* Packages ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local list_of_packages fre 
foreach pack of local list_of_packages {
	cap wich `pack'
	if _rc == 111 {
		ssc install `pack'
	}
}

* gtools Faster Stata for big data
cap which gtools
if _rc == 111 net install gtools, from(https://raw.githubusercontent.com/mcaceresb/stata-gtools/master/build/)
cap which ftools
if _rc == 111 net install ftools, from(https://github.com/sergiocorreia/ftools/raw/master/src/)


* helper programs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

run "$do/01_helper_programs.ado"

* exit ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
exit

summarize 0 "A" 2 "C" /// 
	1 "B"


replace event = 9 if missing(ent_short_name) & missing(ent_long_name) & missing(ent_type) & ///
					 missing(ent_status) & missing(ent_bad) & missing(ent_public) & ///
					 missing(ent_spinout_from) & missing(ent_absorbed_by) & missing(ent_acquired_by)

la def event 0 "Error" 1 "Initial definitions (Jan2001)" 2 "New FI" 3 "Acquisition with merger" /// 
				  4 "Acquisition w/out merger" 5 "Change of name" 6 "Change in FI type" 7 "Change of status" ///
				  8 "Spinoff" 9 "Misc. news" 


forval i = 1/`=sc_b' {
	foreach a in `b' {
		do c
	}
}

foreach var of varlist ba bb `bc' {
	
}
foreach num of numlist `a'(1)`asdf' {
	alskdjf `=asdf`a''
}
foreach n in p {

}
foreach num of numlist -1(.5)2.5{
	alskdjf 
}


foreach num of num $as/`=alksjdf'{
           display `num'
}

cap pr asd -1
	asd
end

foreach i of local a  {
	
}

if (tm(2)==8 & 2>1 & 2) {
	asd
}


if ("$foo" == "") {
	asd
}

prog foobar
	asd
	describe
	append
the end
asd
end

di "asd"
di `"asd"'
`i'
foreach i of local ies {
	su `i'
}

foreach var of varlist asd {
	asd
	$alkjsdf
	"$alskdjf"
	"${laksdjf}"
	${alsdjfl}
}

global asdlfkj "laskdjf//sadf$alskdjf/lksjdf"

/*---------------------------------------------------------------------------
	Sanity check: create total credit, to validate data
---------------------------------------------------------------------------*/
cap asd asd
`as`foo'd'
	cap ado uninstall derc
`asd'

qui {
	reg price mpg, r
	
}

{
	reg price mpg, r
	
}

if 0 sysuse auto 
qui sum if a == b, d 
qui {
	reg y x, r
	
}


delimit cr
#delimit;
#delimit;

sysuse
    auto;
* laskd;
// sadf

reg price
    mpg
    weight
    length;

#delimit;
sysuse
    auto;
reg price
    mpg
    weight
    length if price > 10;
di if a==1 | 
      a==2
#delimit cr
#delimit cr
${asd}

	net install derc, from("C:\Git\peru-sbs-rcd\`'stata")
	pr drop _all	


* comment
asd * asdasdasd
di 4 * 9
     * comment
di 3 * 2 

`cap'
di 3 u 5 

foo // bar
foo /// bar
spam "asd"


di 3 / 2
di 3 * 3
di 3 u 2 
di 3 . 2 

$asdlkflaksjdfj
di "`aslkadjsfd'"
di "${aalksdjfsd}" 
di "asdlaksjdf"
$alskdjf
a
// --------------------------------------------------------------------------
// Setup
// --------------------------------------------------------------------------
	include common.doh
	log using "$log/aggregates", smcl replace

	* Months of analysis
	loc t0 = tm(2001m01)
	loc tn = tm(2016m12) // 2012m08
	loc replace 0
	ivreghdfe a b c
	loc foo : bar spam
	loc a = 123
	loc b "asd"
	loc c asdasd
	replace 2 = 3
	use, clear

	foo loc asd 

program asd
	describe ending
	su
end

forvalu i = 1(2)10 {
	asd
}


loc a = 2
cap pr drop process_all
pr define process_all
syntax, T0(integer) TN(integer) [TIMEIT] [REPLace(integer 1)]
	noi di as text  " {break}{title: Procesando datos}"
	if ("`timeit'"!="") {
		qui timer clear 10
		qui timer on 10
	}
end

gen double x = 123

loc asd : list 213
loc asd fasd asdasd : 2

local asd



mata:
	J(1,1,1)
end

python: 

end


exit



sysuse auto, clear
reg price weight gear
su turn
tab turn
exit