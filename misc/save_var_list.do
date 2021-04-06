// save list of varibles to a file for autocomplete
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* get list of vars
ds, alpha
local list_of_vars = "`r(varlist)'"

* save to a file in /tmp/folder
tempname myfile
local saving "/tmp/st_vars.list"
file open `myfile' using "`saving'", write text replace
file write `myfile' "`list_of_vars'" 
di "`saving'"
file close `myfile'
