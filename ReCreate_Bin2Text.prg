*ReCreate all Bin2Text files from there text representation and compile

DO FoxBin2Prg.PRG WITH JUSTPATH(FULLPATH("","")),"Prg2Bin",,,,,,,,,FULLPATH("Create_Project.cfg","")

BUILD PROJECT Bin2Text.EXE FROM Bin2Text.pjx RECOMPILE
