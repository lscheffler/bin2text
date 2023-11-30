*BuildMe.prg for for Bin2Text
*
* This program should perform any build tasks necessary for the project, such
* as updating version numbers in code or include files. This program can use the public
* variables discussed in the documentation as necessary.

* This code is specific for Bin2Text project
* insert projects version number into stuff.h

local;
 lcText,;
 lnLen,;
 lnStart

lcText  = filetostr('stuff.h')
lnStart = atc('#DEFINE dcB2T_Verno',m.lcText)
lnLen   = atc(0h0A,substr(m.lcText,m.lnStart))
lcText  = stuff(m.lcText,m.lnStart,m.lnLen-1,'#DEFINE dcB2T_Verno							"'+m.pcVersion+'"')

strtofile(m.lcText,'stuff.h')

return
