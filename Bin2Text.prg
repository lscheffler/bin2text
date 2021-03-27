LOCAL;
 lcProg,;
 lcDrive

lcProg  = SYS(16)
lcDrive = JUSTDRIVE(lcProg)

_SCREEN.CAPTION   = ' - SF Bin2Text'

*Menü nach Path laden (.mpr ist im Pfad)
DO lcDrive+'\SE\TOOLS\Start_Project.prg' WITH;
 lcProg,;
 'NONE',;
 RGB(000,000,255),;		&&135,251,057
 RGB(255,255,255),;		&&000,000,000
 'Graphics\Tools.ico'