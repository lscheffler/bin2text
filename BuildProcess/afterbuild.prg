* This program should can tasks like
* - FoxBin2Prg, if the automatic way was not used
* - git processing like add, commit or push
* - set debug info On in pjx or include file
*
* The program runs after
* - FoxBin2Prg is, if enabled, run
* - Thor files are created and zipped
* - git is, if enabled, run
*
* This program can use the public
* variables discussed in the documentation as necessary.

* Bin2Text for whole project
DO Pjx2Commit IN (_SCREEN.gcB2T_App) WITH .T.
return
