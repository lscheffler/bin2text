LPARAMETERS;
 tv01,tv02,tv03,tv04,tv05,tv06,tv07,tv08,;
 tv09,tv10,tv11,tv12,tv13,tv14,tv15,tv16,;
 tv17,tv18,tv19,tv20,tv21,tv22,tv23,tv24

*!*	<pdm>
*!*	<descr>Just an error catcher.</descr>
*!*	<params name="tv01, .., tv24" type="Variant" byref="0" dir="" inb="1" outb="0">
*!*	<short>Dummies</short>
*!*	<detail></detail>
*!*	</params>
*!*	<remarks>
*<p>
* This program stores functions to wrap Fernando D. Bozzo
* <a href="http://vfpx.codeplex.com/wikipage?title=FoxBin2Prg&referringTitle=Home">FoxBin2Prg</a> for IDE purposes.
*</p>
*</remarks>
*!*	<copyright><i>&copy; 16.4.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

SwitchErrorHandler(.T.)
HelpMsg(0)
SwitchErrorHandler(.F.)

FUNCTION Pjx2Commit	&&Create a commit to git.
 LPARAMETERS;
  tlAll

*!*	<pdm>
*!*	<descr>Create a commit to git.</descr>
*!*	<params name="tlAll" type="Boolean" byref="0" dir="" inb="1" outb="1">
*!*	<short>Process whole path.</short>
*!*	<detail></detail>
*!*	</params>
*!*	<retval type="Boolean">True if successfull.</retval>
*!*	<remarks>This calls FoxBin2PRG to process active project or all projects in the path. And runs a git commit.</remarks>
*!*	<copyright><i>&copy; 05.6.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

*!*	<pdm>
*!*	<change date="{^2015-06-04,11:19:00}">Changed by: SF<br />
*!*	New parameter <pdmpara num="1" />
*!*	</change>
*!*	</pdm>


 IF !VARTYPE(tlAll)='L' THEN
  HelpMsg(3)
  RETURN .F.
 ENDIF &&!VARTYPE(tlAll)='L'

 IF _VFP.STARTMODE#0 THEN
  HelpMsg(4)
  RETURN .F.
 ENDIF &&F_VFP.StartMode#0

 SwitchErrorHandler(.T.)

 IF !PEMSTATUS(_SCREEN,"gcB2T_GitPjx",5) THEN
  LOCAL;
   lcStorage AS CHARACTER

  Construct_Objects()
  lcStorage = _SCREEN.frmB2T_Envelop.cusB2T.Storage_Check()
  _SCREEN.frmB2T_Envelop.cusB2T.Storage_Close(lcStorage,.T.)
  Destruct_Objects()

  IF ISNULL(lcStorage) THEN
   SwitchErrorHandler(.F.)
   RETURN
  ENDIF &&ISNULL(lcStorage)
 ENDIF &&!PEMSTATUS(_SCREEN,"gcB2T_GitPjx",5)

 SwitchErrorHandler(.F.)
 IF Convert_Pjx(.F.,IIF(tlAll,3,1),ICASE(tlAll,0,_SCREEN.gcB2T_GitPjx="1",4,3)) THEN
  SwitchErrorHandler(.T.)
  _SCREEN.ADDPROPERTY('gcOld_Path',FULLPATH(CURDIR()))
  CD (JUSTPATH(_SCREEN.gcB2T_Path))

  IF Is_git() THEN
*!*	Changed by: SF 4.6.2015
*!*	<pdm>
*!*	<change date="{^2015-06-04,11:23:00}">Changed by: SF<br />
*!*	<p>New way to run <i>git</i> withour <expr>RUN</expr></p>
*<p>Run <i>git commit</i> only if somthing is to commit.</p>
*!*	</change>
*!*	</pdm>
   LOCAL;
    lnSec AS NUMBER

*!*	   DELETE FILE git_x.tmp
*!*	   lnSec = SECONDS()
*!*	   DO WHILE FILE('git_x.tmp')
*!*	    WAIT "" WINDOW TIMEOUT 0.2
*!*	    IF SECONDS()-lnSec>=2 THEN
*!*	     EXIT
*!*	    ENDIF &&SECONDS()-lnSec>=2
*!*	   ENDDO &&FILE('git_x.tmp')

   LOCAL;
    lcBat  AS CHARACTER,;
    lcPath AS CHARACTER

   TEXT TO lcBat NOSHOW TEXTMERGE
"<<_SCREEN.gcB2t_git>>" add -A
"<<_SCREEN.gcB2t_git>>" status --porcelain>git_x.tmp
   ENDTEXT &&lcBat
   STRTOFILE(lcBat,'git_x.bat')

   lcPath = ADDBS(FULLPATH(CURDIR()))
   IF Run_ExtApp('cmd /c '+lcPath+'git_x.bat',lcPath,'HID') THEN

*!*	    lnSec = SECONDS()
*!*	    DO WHILE !FILE('git_x.tmp')
*!*	     WAIT "" WINDOW TIMEOUT 0.2
*!*	     IF SECONDS()-lnSec>=2 THEN
*!*	      EXIT
*!*	     ENDIF &&SECONDS()-lnSec>=2
*!*	    ENDDO &&!FILE('git_x.tmp')
    IF FILE('git_x.tmp') AND LEN(FILETOSTR('git_x.tmp'))>0 THEN
*!*	Changed by: SF 17.9.2015
*!*	<pdm>
*!*	<change date="{^2015-09-17,04:43:00}">Changed by: SF<br />
*!*	run git w/o CMD
*!*	</change>
*!*	</pdm>
     IF TYPE('_SCREEN.gcB2T_Commit')="C" AND _SCREEN.gcB2T_Commit=="1" THEN
      Run_git('commit -m "'+CHRTRAN(TTOC(DATETIME(),3),'T',' ')+'" -m "auto-commit by RunB2T.app"',.F.,.F.)
      ??' - auto commit'
     ELSE  &&TYPE('_SCREEN.gcB2T_Commit')="C" AND _SCREEN.gcB2T_Commit=="1"
      Run_git('commit',.T.,.F.)
     ENDIF &&TYPE('_SCREEN.gcB2T_Commit')="C" AND _SCREEN.gcB2T_Commit=="1"
*!*	/Changed by: SF 17.9.2015
    ELSE &&FILE('git_x.tmp') AND LEN(FILETOSTR('git_x.tmp'))>0
     ??' - nothing to commit'
    ENDIF &&FILE('git_x.tmp') AND LEN(FILETOSTR('git_x.tmp'))>0
    DELETE FILE git_x.*
   ENDIF &&Run_ExtApp('cmd /c 'lcPath+'git_x.bat',lcPath,'HID')
*!*	/Changed by: SF 4.6.2015

  ELSE  &&Is_git()
   =MESSAGEBOX('Run "git init" to enable git.',0,'',10000)
  ENDIF &&Is_git()

  CD (_SCREEN.gcOld_Path)
  REMOVEPROPERTY(_SCREEN,'gcOld_Path')
  SwitchErrorHandler(.F.)

 ENDIF &&Convert_Pjx(.F.,IIF(tlAll,3,1),ICASE(tlAll,0,_SCREEN.gcB2T_GitPjx="1",4,3))
ENDFUNC &&Pjx2Commit

FUNCTION Inter_Active &&Run settings mask.
 LPARAMETERS;
  tcHelp

*!*	<pdm>
*!*	<descr>Run settings mask.</descr>
*!*	<params name="tcHelp" type="Variant" byref="0" dir="" inb="1" outb="1">
*!*	<short>Any value will raise help text.</short>
*!*	<detail></detail>
*!*	</params>
*!*	<remarks>To configure this program.</remarks>
*!*	<copyright><i>&copy; 14.4.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 IF PCOUNT()=1 THEN
  HelpMsg(7)
  RETURN .F.
 ENDIF &&PCOUNT()=1

 IF _VFP.STARTMODE#0 THEN
  HelpMsg(8)
  RETURN .F.
 ENDIF &&F_VFP.StartMode#0

 SwitchErrorHandler(.T.)
 Construct_Objects()
 _SCREEN.ADDPROPERTY('gcOld_Path',FULLPATH(CURDIR()))
 CD (JUSTPATH(_SCREEN.gcB2T_Path))

 _SCREEN.frmB2T_Envelop.cusB2T.Storage_Check(.T.)
 Destruct_Objects()

 CD (_SCREEN.gcOld_Path)
 REMOVEPROPERTY(_SCREEN,'gcOld_Path')
 SwitchErrorHandler(.F.)
ENDFUNC &&Inter_Active

FUNCTION Convert_Pjx &&Runs FoxBin2Prg for multiple projects.
 LPARAMETERS;
  tlToBin,;
  tnProjects,;
  tnMode

*!*	<pdm>
*!*	<descr>Runs FoxBin2Prg for multiple projects.</descr>
*!*	<params name="tlToBin" type="Boolean" byref="0" dir="" inb="0" outb="0">
*!*	<short>Direction of operation.</short>
*!*	<detail>If true, create binaries for the projects defined by <pdmpara num="2" />.</detail>
*!*	</params>
*!*	<params name="tnProjects" type="Numeric" byref="0" dir="" inb="0" outb="0">
*!*	<short>Defines what project to be processed</short>
*!*	<detail>
*<dl>
* <dt>0</dt><dd>Use <expr>GETFILE()</expr> to define the file. Input is a text file if <pdmpara num="1"/>.</dd>
* <dt>1</dt><dd>Active project.</dd>
* <dt>2</dt><dd>All projects open in IDE</dd>
* <dt>3</dt><dd>All projects in home path.</dd>
* <dt>4</dt><dd>All projects in home path, with subdirs.</dd>
*</dl>
*</detail>
*!*	</params>
*!*	<params name="tnMode" type="Numeric" byref="0" dir="" inb="0" outb="0">
*!*	<short>Defines FoxBinToPrg mode of operation of pjx files.</short>
*!*	<detail>
*<dl>
* <dt>0</dt><dd>Use <expr>"*"</expr> Convert files of project, project file and projecthook if defined.</dd>
* <dt>1</dt><dd>Use <expr>"*-"</expr> Convert files of project and projecthook (if defined).</dd>
* <dt>2</dt><dd>Use <expr>""</expr> Convert project file.</dd>
* <dt>3</dt><dd>Use <expr>"*-"</expr> Convert files of project, do not process projecthook (if defined). Keep project open</dd>
* <dt>4</dt><dd>Use <expr>"*"</expr> Convert files of project, project file, do not process projecthook (if defined).</dd>
*</dl>
*</detail>
*!*	<retval type="Boolean">True if successfull.</retval>
*!*	</params>
*!*	<copyright><i>&copy; 12.6.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>

*!*	<change date="{^2015-05-12,09:56:00}">Changed by: SF<br />
*!*	New value for parameter <pdmpara num="3" /> "4"
*!*	</change>
*!*	</pdm>
*!*	<change date="{^2015-06-12,15:56:00}">Changed by: SF<br />
*!*	New value for parameter <pdmpara num="2" /> "4"
*!*	</change>
*!*	</pdm>


 LOCAL;
  lcOldExact  AS CHARACTER

 DO CASE
  CASE VARTYPE(tlToBin)#'L'
   tlToBin = '?'
  CASE VARTYPE(tnProjects)#'N'
   tnProjects = 0
  CASE !BETWEEN(tnProjects,0,4)
   tlToBin = '?'
  CASE VARTYPE(tnMode)#'N'
   tnProjects = 0
  CASE !BETWEEN(tnMode,0,4)
   tlToBin = '?'
  OTHERWISE
 ENDCASE

 lcOldExact = SET("Exact")
 SET EXACT ON
 IF VARTYPE(tlToBin)='C';
   AND INLIST(LOWER(tlToBin),'?','/?','-?','h','/h','-h','help','/help','-help') THEN

  HelpMsg(1)

  SET EXACT &lcOldExact
  RETURN .F.
 ENDIF &&VARTYPE(tlToBin)='C' AND INLIST(LOWER(tlToBin),'?','/?','-?','h','/h','-h','help','/help','-help')

 SET EXACT &lcOldExact

 IF _VFP.STARTMODE#0 THEN
  HelpMsg(2)
  RETURN .F.
 ENDIF &&F_VFP.StartMode#0

 SwitchErrorHandler(.T.)
 RELEASE;
  lcOldExact

 LOCAL;
  lcProj      AS CHARACTER,;
  lcPath      AS CHARACTER,;
  lcOldPath   AS CHARACTER,;
  lnProj      AS NUMBER,;
  lnProjs     AS NUMBER,;
  llPath      AS BOOLEAN,;
  llCheckAll  AS BOOLEAN,;
  lvMode      AS VARIANT,;
  loProject   AS PROJECT

 lnProjs = 1

 LOCAL ARRAY;
  laProjects(lnProjs,3),;
  laFiles(1,2)

 CLEAR

 IF tlToBin THEN
  IF MESSAGEBOX('Create Binary',4+32+256,'FoxBin2Text',10000)#6 THEN
   ?'Stopped by user'
   SwitchErrorHandler(.F.)
   RETURN .F.
  ENDIF &&MESSAGEBOX('Create Binary',4+32+256,'FoxBin2Text',10000)#6
  ?'Process to binary'
 ELSE  &&tlToBin

  ?'Process to text'
 ENDIF &&tlToBin

 laProjects = .NULL.
 laFiles    = .NULL.

 lcOldPath  = FULLPATH(CURDIR())

 llCheckAll = !tlToBin
 DO CASE
  CASE tnProjects=0
*Getfile
   llCheckAll = .F.

   LOCAL;
    lcSourceExt AS CHARACTER

   IF tlToBin THEN
    LOCAL;
     loConverter AS OBJECT,;
     loInfo      AS OBJECT

    Construct_Objects()
    IF _SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.) THEN
     SwitchErrorHandler(.F.)
     RETURN .F.
    ENDIF &&_SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(@lcStorage,@loConverter,.T.)

*Just guess
    lcSourceExt = "PJ2"
   ELSE  &&lcSourceExt AS CHARACTER,IF tlToBin
    lcSourceExt = "PJX"
   ENDIF &&lcSourceExt AS CHARACTER,IF tlToBin

   lcProj = GETFILE(lcSourceExt)
   lcPath = JUSTPATH(lcProj)

   IF !EMPTY(lcProj) AND tlToBin THEN
*get local text extension for project

    loInfo      = loConverter.Get_DirSettings(lcPath)
    lcSourceExt = UPPER(loInfo.c_PJ2)

    loInfo      = .NULL.
    loConverter = .NULL.
    Destruct_Objects()
   ENDIF &&tlToBin

   IF ISBLANK(lcProj) THEN
    CD (lcOldPath)
    ?'No project found'
    SwitchErrorHandler(.F.)
    RETURN .F.
   ENDIF &&!EMPTY(lcProj) AND ISBLANK(lcProj)

*!*	Changed by: SF 11.6.2015
*!*	<pdm>
*!*	<change date="{^2015-06-11,20:21:00}">Changed by: SF<br />
*!*	reworked wrong bracket
*!*	</change>
*!*	</pdm>

   IF tlToBin AND !UPPER(JUSTEXT(lcProj))==lcSourceExt THEN
*   IF tlToBin AND !UPPER(JUSTEXT(lcProj)==lcSourceExt) THEN
    MESSAGEBOX("File is not a valid text representation of a project in this folder")
    SwitchErrorHandler(.F.)
    RETURN .F.
   ENDIF &&tlToBin AND !UPPER(JUSTEXT(lcProj))==lcSourceExt

*!*	/Changed by: SF 11.6.2015

   lnProjs = 1
   _SCREEN.ADDPROPERTY('gaFiles(1,2)')
   _SCREEN.gaFiles(1,1) = FORCEEXT(lcProj,'PJX')
   _SCREEN.gaFiles(1,2) = ICASE(tnMode=3,"",tnMode=4,"",.NULL.)

   lcPath = JUSTPATH(lcProj)
   CD (lcPath)

*  &&tnProjects=0
  CASE tnProjects=1
*active project
   llCheckAll = .F.

   IF _VFP.PROJECTS.COUNT=0 THEN
    CD (lcOldPath)
    ?'No project found'
    SwitchErrorHandler(.F.)
    RETURN .F.
   ENDIF &&_VFP.PROJECTS.COUNT=0

   lnProjs = 1
   _SCREEN.ADDPROPERTY('gaFiles(1,2)')
   _SCREEN.gaFiles(1,1) = _VFP.ACTIVEPROJECT.NAME
   _SCREEN.gaFiles(1,2) = ICASE(tnMode=3,"",tnMode=4,"",_VFP.ACTIVEPROJECT.PROJECTHOOKLIBRARY)

   lcPath = JUSTPATH(_VFP.ACTIVEPROJECT.NAME)
   CD (lcPath)

*  &&tnProjects=1
  CASE tnProjects=2
*open projects
   llCheckAll = .F.

   lnProjs = _VFP.PROJECTS.COUNT
   IF lnProjs=0 THEN
    CD (lcOldPath)
    ?'No project found'
    SwitchErrorHandler(.F.)
    RETURN .F.
   ENDIF &&lnProjs=0

   _SCREEN.ADDPROPERTY('gaFiles('+TRIM(PADR(lnProjs,11))+',2)')

   lcPath = JUSTPATH(_VFP.ACTIVEPROJECT.NAME)
   CD (lcPath)

   lnProj     = 0
   FOR EACH loProject IN _VFP.PROJECTS FOXOBJECT
    lnProj = lnProj+1
    _SCREEN.gaFiles(lnProj,1) = loProject.NAME
    _SCREEN.gaFiles(lnProj,2) = ICASE(tnMode=3,"",tnMode=4,"",loProject.PROJECTHOOKLIBRARY)
   ENDFOR &&loProject

*  &&tnProjects=2
  CASE tnProjects=3
*path
*!*	Changed by: SF 15.9.2015
*!*	<pdm>
*!*	<change date="{^2015-09-15,10:45:00}">Changed by: SF<br />
*!*	Do not delete obsolete libraries etc on <b>all</b> run. This runs only base dir.
*!*	Hidden projects in subdirectories storing extra stuff might exist.
*!*	</change>
*!*	</pdm>
   llCheckAll = .F.
*!*	/Changed by: SF 15.9.2015

   LOCAL;
    lcSourceExt AS CHARACTER,;
    loConverter AS OBJECT,;
    loInfo      AS OBJECT

   Construct_Objects()
   IF _SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.) THEN
    SwitchErrorHandler(.F.)
    RETURN .F.
   ENDIF &&_SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(@lcStorage,@loConverter,.T.)

   lcPath = JUSTPATH(_SCREEN.gcB2T_Path)

   CD (lcPath)

   IF tlToBin THEN
*get local text extension for project
    loInfo      = loConverter.Get_DirSettings(lcPath)
    lcSourceExt = loInfo.c_PJ2

   ELSE  &&tlToBin
    lcSourceExt = "PJX"
   ENDIF &&tlToBin

   loInfo      = .NULL.
   loConverter = .NULL.
   Destruct_Objects()

   lnProjs = ADIR(laFiles,'*.'+lcSourceExt,'HS')

   IF lnProjs=0 THEN
    CD (lcOldPath)
    ?'No project found'
    SwitchErrorHandler(.F.)
    RETURN .F.
   ENDIF &&lnProjs=0

   _SCREEN.ADDPROPERTY('gaFiles('+TRIM(PADR(lnProjs,11))+',2)')

   FOR lnProj = 1 TO lnProjs
    _SCREEN.gaFiles(lnProj,1) = FORCEPATH(FORCEEXT(laFiles(lnProj,1),"PJX"),lcPath)
    _SCREEN.gaFiles(lnProj,2) = ICASE(tnMode=3,"",tnMode=4,"",.NULL.)
   ENDFOR &&lnProjs
*  &&tnProjects=3
  CASE tnProjects=4
*path, recursive
   LOCAL;
    lcSourceExt AS CHARACTER,;
    loConverter AS OBJECT

   Construct_Objects()
   IF _SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.) THEN
    SwitchErrorHandler(.F.)
    RETURN .F.
   ENDIF &&_SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(@lcStorage,@loConverter,.T.)

   lcPath = JUSTPATH(_SCREEN.gcB2T_Path)

   CD (lcPath)

   _SCREEN.ADDPROPERTY('gaFiles(1,2)')

   ScanDir(lcPath,tlToBin,loConverter)

   loConverter = .NULL.
   Destruct_Objects()

   lnProjs = IIF(EMPTY(_SCREEN.gaFiles),0,ALEN(_SCREEN.gaFiles,1))

   FOR lnProj = 1 TO lnProjs
    _SCREEN.gaFiles(lnProj,2) = ICASE(tnMode=3,"",tnMode=4,"",.NULL.)
   ENDFOR &&lnProjs
*  &&tnProjects=4
  OTHERWISE
   CD (lcOldPath)
   ?'Parameter not defined'
   SwitchErrorHandler(.F.)
   RETURN .F.
 ENDCASE

 DO CASE
  CASE tnMode=0
   lvMode     = "*"
   ??', generate projects and files of list'
  CASE tnMode=1
   llCheckAll = .F.
   lvMode     = "*-"
   ??', generate files list'
  CASE tnMode=2
   llCheckAll = .F.
   lvMode     = ""
   ??', generate projects'
  CASE tnMode=3
   llCheckAll = .F.
   lvMode     = "*-"
   ??', generate files list'
  CASE tnMode=4
   lvMode     = "*"
   ??', generate projects and files of list'
  OTHERWISE
   lvMode     = "*"
   ??', generate projects and files of list'
 ENDCASE

*close all the projects in the IDE / from StorePjx
*just to keep data over CLEAR ALL
 _SCREEN.ADDPROPERTY('gaProjects(1,2)')

 IF tnMode=3 THEN
*keep projects open, (do not parse hooks)
  _SCREEN.gaProjects = .NULL.
 ELSE  &&tnMode=3
  lnProjs = _VFP.PROJECTS.COUNT

  IF lnProjs=0 THEN
*nothing to do
   _SCREEN.gaProjects = .NULL.
   FOR lnProj = 1 TO lnProjs
    _SCREEN.gaFiles(lnProj,2) = "" && "no hook defined" -> no hook processed :)
   ENDFOR &&lnProjs
  ELSE  &&lnProjs=0
   DIMENSION;
    _SCREEN.gaProjects(lnProjs,2)

*!*	Changed by SF 12.5.2015
*!*	<pdm>
*!*	<change date="{^2015-05-12,11:36:00}">Changed by SF<br />
*!*	Make <expr>ACTIVEPROJECT</expr> active after reopen
*!*	</change>
*!*	</pdm>

*Active on top, to make it active on reopen
   lnProj = 1
   loProject = _VFP.ACTIVEPROJECT
   _SCREEN.gaProjects(lnProj,1) = loProject.NAME
*SF internal
   _SCREEN.gaProjects(lnProj,2) = VARTYPE(loProject.PROJECTHOOK)='O';
    AND !ISNULL(loProject.PROJECTHOOK);
    AND PEMSTATUS(loProject.PROJECTHOOK,'glCompileAll',5);
    AND loProject.PROJECTHOOK.glCompileAll
*/SF internal
   loProject.CLOSE

*   lnProj = 0

*!*	/Changed by SF 12.5.2015

   FOR EACH loProject IN _VFP.PROJECTS FOXOBJECT
    lnProj = lnProj+1
    _SCREEN.gaProjects(lnProj,1) = loProject.NAME
*SF internal
    _SCREEN.gaProjects(lnProj,2) = VARTYPE(loProject.PROJECTHOOK)='O';
     AND !ISNULL(loProject.PROJECTHOOK);
     AND PEMSTATUS(loProject.PROJECTHOOK,'glCompileAll',5);
     AND loProject.PROJECTHOOK.glCompileAll
*/SF internal
    loProject.CLOSE
   ENDFOR &&loProject
  ENDIF &&lnProjs=0
 ENDIF &&tnMode=3


*just to keep data over CLEAR ALL
 _SCREEN.ADDPROPERTY('gcOld_Path',lcOldPath)
 _SCREEN.ADDPROPERTY('gvMode',lvMode)
 _SCREEN.ADDPROPERTY('glToBin',tlToBin)
 _SCREEN.ADDPROPERTY('glCheckAll',llCheckAll)

*to remove Classlibs so we can recreate
 CLEAR ALL

 LOCAL ARRAY;
  laFiles(1)

 ACOPY(_SCREEN.gaFiles,laFiles)
 REMOVEPROPERTY(_SCREEN,'gaFiles')

*process Transformation
 Construct_Objects()

 _SCREEN.frmB2T_Envelop.cusB2T.Process_Bin2Text(@laFiles,_SCREEN.glToBin,_SCREEN.gvMode,_SCREEN.glCheckAll AND _SCREEN.gcB2T_Delete=="1")
 Destruct_Objects()

 CLEAR ALL

*/Move
 REMOVEPROPERTY(_SCREEN,'gvMode')
 REMOVEPROPERTY(_SCREEN,'glToBin')
 REMOVEPROPERTY(_SCREEN,'glCheckAll')


*Move
 LOCAL;
  lcProj      AS CHARACTER,;
  lcSourceExt AS CHARACTER,;
  lnProj      AS NUMBER,;
  lnProjs     AS NUMBER,;
  lnReturn    AS NUMBER,;
  llNotFound  AS BOOLEAN,;
  loProject   AS PROJECT

 IF !ISNULL(_SCREEN.gaProjects(1,1)) THEN

*/process Transformation
  ?''+0h0d0a+'reopen files'

*reopen  all the projects in the IDE / from ReStorePjx
  lnProjs = ALEN(_SCREEN.gaProjects,1)
  FOR lnProj = lnProjs TO 1 STEP -1
   lcProj = _SCREEN.gaProjects(lnProj,1)
   IF !FILE(lcProj) THEN
    LOOP
   ENDIF &&!FILE(lcProj)

   llNotFound = .T.
   FOR EACH loProject IN _VFP.PROJECTS FOXOBJECT
    IF UPPER(JUSTSTEM(loProject.NAME))==lcProj THEN
     llNotFound = .F.
     EXIT
    ENDIF &&UPPER(JUSTSTEM(loProject.NAME))==lcProj
   ENDFOR &&loProject

   IF llNotFound THEN
    MODIFY PROJECT (lcProj) NOWAIT SAVE
    loProject = _VFP.ACTIVEPROJECT
    loProject.VISIBLE = .F.
    loProject.VISIBLE = .T.
*SF internal
    IF VARTYPE(loProject.PROJECTHOOK)='O';
      AND !ISNULL(loProject.PROJECTHOOK);
      AND PEMSTATUS(loProject.PROJECTHOOK,'glCompileAll',5) THEN
     loProject.PROJECTHOOK.glCompileAll = _SCREEN.gaProjects(lnProj,2)
    ENDIF &&VARTYPE(loProject.PROJECTHOOK)='O' AND !ISNULL(loProject.PROJECTHOOK) AND PEMSTATUS(loProject. ...
*/SF internal
   ENDIF &&llNotFound
  ENDFOR &&lnProj
 ENDIF &&!ISNULL(_SCREEN.gaProjects(1,1))

 REMOVEPROPERTY(_SCREEN,'gaProjects')

*!*	Changed by: SF 5.6.2015
*!*	<pdm>
*!*	<change date="{^2015-06-05,11:14:00}">Changed by: SF<br />
*!*	Output of current git branch
*!*	</change>
*!*	</pdm>
 lcProj = getbranch()
 IF !EMPTY(lcProj) THEN
  ?'On branch '+lcProj
 ENDIF &&!EMPTY(lcProj)
*!*	/Changed by: SF 5.6.2015

 CD (_SCREEN.gcOld_Path)
 REMOVEPROPERTY(_SCREEN,'gcOld_Path')

 SwitchErrorHandler(.F.)
ENDFUNC &&Convert_Pjx

FUNCTION Convert_Array	&&Runs FoxBin2Prg for multiple files.
 LPARAMETERS;
  tlToBin,;
  tcMode,;
  taFiles

*!*	<pdm>
*!*	<descr>Runs FoxBin2Prg for multiple files.</descr>
*!*	<params name="tlToBin" type="Boolean" byref="0" dir="" inb="0" outb="0">
*!*	<short>Direction of operation.</short>
*!*	<detail>
*<p>If true, create binaries from the text files corespondening <pdmpara num="3" />.</p>
*<p>If false create text files.(Default)</p>
*</detail>
*!*	</params>
*!*	<params name="tcMode" type="Character" byref="0" dir="" inb="1" outb="0">
*!*	<short>Mode for pjx files.</short>
*!*	<detail>Pjx ("*","*-","") parameters as used by FoxBin2Prg.</detail>
*!*	</params>
*!*	<params name="taFiles" type="Array" byref="1" dir="" inb="0" outb="0">
*!*	<short>Array with files</short>
*!*	<detail>
* <p>One column, full qualified filename of binary</p>
* <p>Optional second column, if first colum is a project, projecthook.</p>
*</detail>
*!*	</params>
*!*	<retval type="Boolean">True if successfull.</retval>
*!*	<remarks>
*<p>Transfers a bunch of files</p>
*<p>Processes binaries. If <pdmpara num="1"/> the source files will be determined be the code.</p>
*<note id="E" title="Warning">
* Note that the files processed will be cached by the normal process of this programm. A operation that raises deletion
* like <i>Delete obsolete files</i> might delete text files without warning.
*</note>
*</remarks>
*!*	<copyright><i>&copy; 05.6.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 EXTERNAL ARRAY;
  taFiles

*check parameters
 DO CASE
  CASE _VFP.STARTMODE#0
   HelpMsg(10)
   RETURN .F.
  CASE PCOUNT()<3
   tlToBin = '?'
  CASE VARTYPE(tlToBin)#'L'
   tlToBin = '?'
  CASE VARTYPE(tcMode)#'C'
   tlToBin = '?'
  CASE TYPE('ALEN(taFiles)')#'N'
   tlToBin = '?'
  OTHERWISE
   LOCAL;
    lnLoop
   FOR lnLoop = 1 TO ALEN(taFiles)
    IF !TYPE(taFiles(lnLoop,1))='C' THEN
     tlToBin = '?'
     EXIT
    ENDIF &&!TYPE(taFiles(lnLoop,1))='C'
   ENDFOR &&lnLoop
   IF !VARTYPE(tlToBin)='C' AND ALEN(taFiles,2)>1 THEN
    FOR lnLoop = 1 TO ALEN(taFiles)
     IF !TYPE(taFiles(lnLoop,2))='C' OR ISNULL(taFiles(lnLoop,2)) THEN
      tlToBin = '?'
      EXIT
     ENDIF &&!TYPE(taFiles(lnLoop,1))
    ENDFOR &&lnLoop
   ENDIF &&!TYPE(taFiles(lnLoop,2))='C' OR ISNULL(taFiles(lnLoop,2))
 ENDCASE

 IF VARTYPE(tlToBin)='C';
   AND INLIST(LOWER(tlToBin),'?','/?','-?','h','/h','-h','help','/help','-help') THEN
  HelpMsg(1)
  RETURN .F.
 ENDIF &&VARTYPE(tlToBin)='C' AND INLIST(LOWER(tlToBin),'?','/?','-?','h','/h','-h','help','/help','-help')

 SwitchErrorHandler(.T.)
*process Transformation
 Construct_Objects()
 _SCREEN.frmB2T_Envelop.cusB2T.Process_Bin2Text(@taFiles,tlToBin,tcMode)
 Destruct_Objects()
 SwitchErrorHandler(.F.)

ENDFUNC &&Convert_Array

FUNCTION InitMenu	&&Starts the IDE menu.
 LPARAMETERS;
  tcHomePath,;
  tlNoMenu

*!*	<pdm>
*!*	<descr>Starts the IDE menu.</descr>
*!*	<params name="tcHomePath" type="Character" byref="0" dir="" inb="1" outb="1">
*!*	<short>Home path of he actual VFP IDE.</short>
*!*	<detail>The default is not easy. If under <i>git</i> control, <i>git root</i></detail>
*!*	</params>
*!*	<params name="tlNoMenu" type="Boolean" byref="0" dir="" inb="1" outb="1">
*!*	<short>Just read the IDE settings.</short>
*!*	<detail></detail>
*!*	</params>
*!*	<retval type="Boolean"></retval>
*!*	<remarks>
*<p>Read the settings file in <pdmpara num="1" />.</p>
*<p>If the file not exists, create and initialize settings.</p>
*<p>The VFP search path will be altered to keep the path to the application.</p>
*<p>Places menu into <expr>_SYSMENU</expr>.</p>
*</remarks>
*!*	<copyright><i>&copy; 14.4.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 IF _VFP.STARTMODE#0 THEN
  HelpMsg(6)
  RETURN .F.
 ENDIF &&F_VFP.StartMode#0

 DO CASE
  CASE PCOUNT()=0
  CASE VARTYPE(tcHomePath)#'C'
   tcHomePath = '?'
  CASE PCOUNT()=1
  CASE VARTYPE(tlNoMenu)#'L'
   tcHomePath = '?'
  OTHERWISE
 ENDCASE

 lcOldExact = SET("Exact")
 SET EXACT ON
 IF VARTYPE(tcHomePath)='C';
   AND INLIST(LOWER(tcHomePath),'?','/?','-?','h','/h','-h','help','/help','-help') THEN

  HelpMsg(5)

  SET EXACT &lcOldExact
  RETURN .F.
 ENDIF &&VARTYPE(tcHomePath)='C' AND INLIST(LOWER(tcHomePath),'?','/?','-?','h','/h','-h','help','/help','-help')

*!*	Changed by: SF 10.6.2015
*!*	<pdm>
*!*	<change date="{^2015-06-10,21:47:00}">Changed by: SF<br />
*!*	Reset <expr>SET EXACT</expr>
*!*	</change>
*!*	</pdm>

 SET EXACT &lcOldExact

*!*	/Changed by: SF 10.6.2015

 SwitchErrorHandler(.T.)

 LOCAL;
  lcFile AS CHARACTER,;
  lcMenu AS CHARACTER,;
  lcPath AS CHARACTER,;
  lnLoop AS INTEGER

 LOCAL ARRAY;
  laDirs(1)

 lcMenu = ""

 Construct_Objects()

 lcFile = _SCREEN.frmB2T_Envelop.cusB2T.Storage_Check(.F.,tcHomePath)
 IF ISNULL(lcFile) THEN
  ?"Failed to init FoxBin2Prg IDE integration."
 ELSE  &&ISNULL(lcFile)
  _SCREEN.frmB2T_Envelop.cusB2T.Storage_Close(lcFile,.T.)
  IF !tlNoMenu THEN

   lnLoop = 1
   lcFile = SYS(16,lnLoop)
   DO WHILE LEN(lcFile)>0
    lnLoop = lnLoop+1
    IF UPPER(STREXTRACT(lcFile,' ',' ',1))=="INITMENU";
      OR UPPER(JUSTFNAME(STREXTRACT(lcFile,' ',' ',2,2)))=="BIN2TEXT.APP" THEN

     lcPath = UPPER(JUSTPATH(STREXTRACT(lcFile,' ',' ',2,2)))
*     lcMenu = FORCEPATH("Bin2Text.mpx",ADDBS(lcPath))
     lcMenu = "Bin2Text.mpr"
     IF LEN(SET("Path"))#0 THEN
*check VFP path to figure out if we are within
      FOR lnLoop = 1 TO ALINES(laDirs,SET("Path"),';')
       IF lcPath==UPPER(laDirs(lnLoop)) THEN
        lcPath = ""
        EXIT
       ENDIF &&lcPATH==UPPER(laDirs(lnLoop))
      ENDFOR &&lnLoop
      IF !EMPTY(lcPath) THEN
       lcPath = lcPath+';'+SET("Path")
      ENDIF &&!EMPTY(lcPath)
     ENDIF &&LEN(SET("Path"))#0

     IF !EMPTY(lcPath) THEN
      SET PATH TO (lcPath)
     ENDIF &&!EMPTY(lcPath)

*!*	     IF !FILE(lcMenu) THEN
*!*	      lcPath = FILETOSTR('Bin2Text.mpx')
*!*	      STRTOFILE(lcPath,lcMenu)
*!*	     ENDIF &&!FILE(lcMenu)

     EXIT
    ENDIF &&UPPER(STREXTRACT(lcFile,' ',' ',1))=="INITMENU" OR UPPER(JUSTFNAME(STREXTRACT(lcFile,' ',' ',2,1) ...

    lcFile = SYS(16,lnLoop)
   ENDDO &&LEN(lcFile)>0


   IF !EMPTY(lcMenu) THEN
    DO (lcMenu)
   ENDIF &&!EMPTY(lcMenu)

  ENDIF &&!tlNoMenu
 ENDIF &&ISNULL(lcFile)
 Destruct_Objects()

 SwitchErrorHandler(.F.)

ENDFUNC &&InitMenu

*!*	Changed by: SF 15.9.2015
*!*	<pdm>
*!*	<change date="{^2015-09-15,08:03:00}">Changed by: SF<br />
*!*	New procedures <see pem="git_bash" /> <see pem="git_gitk" /> to run a git bash and history.
*!*	</change>
*!*	</pdm>

PROCEDURE git_bash		&&run bash
*!*	<pdm>
*!*	<descr>Run <i>git bash</i> for current directory.</descr>
*!*	<remarks>This is experimental. <i>git bash</i> works not as expected.</remarks>
*!*	<comment>
*!*	<retval type=""></retval>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright><i>&copy; 15.9.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 LOCAL;
  lcPath AS CHARACTER,;
  lc_Git AS CHARACTER

 lcPath = ADDBS(FULLPATH(CURDIR()))

 IF Get_git_Path(@lc_Git) THEN
  llReturn = Run_ExtApp('"'+FORCEPATH('git-bash.exe',JUSTPATH(JUSTPATH(lc_Git)))+'" ',lcPath,'NOR',,.T.)
 ENDIF &&Get_git_Path(@lc_Git)
ENDPROC &&git_bash

PROCEDURE git_gitk &&run gitk
*!*	<pdm>
*!*	<descr>Run <i>gitk</i> for current directory.</descr>
*!*	<remarks>GUI for <i>git</i> history.</remarks>
*!*	<comment>
*!*	<retval type=""></retval>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright><i>&copy; 15.9.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>
 LOCAL;
  lcPath AS CHARACTER

 lcPath = ADDBS(FULLPATH(CURDIR()))

 IF Is_git() THEN
  llReturn = Run_ExtApp('"'+FORCEPATH('gitk.exe',JUSTPATH(_SCREEN.gcB2t_git))+'" ',lcPath,'NOR',,.T.)
 ENDIF &&Is_git()
ENDPROC &&git_gitk
*!*	/Changed by: SF 15.9.2015

*!*	Changed by SF 11.4.2015
*!*	<pdm>
*!*	<change date="{^2015-04-11,09:01:00}">Changed by SF<br />
*!*	Move to classes
*!*	</change>
*!*	</pdm>

FUNCTION Construct_Objects	&&Internal. Create FoxBin2PRG instance

*!*	<pdm>
*!*	<descr>Instantiate an instance of the business object of this application.</descr>
*!*	<copyright><i>&copy; 14.4.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 IF PEMSTATUS(_SCREEN,'frmB2T_Envelop',5) AND !ISNULL(_SCREEN.frmB2T_Envelop) THEN
  RETURN
 ENDIF &&PEMSTATUS(_SCREEN,'frmB2T_Envelop',5) AND !ISNULL(_SCREEN.frmB2T_Envelop)

*for testing purposes
* lcx = 'e:\se\tools\bin2text\library\Bin_2_Text.vcx'
*runnning
 lcx = 'Bin_2_Text.vcx'

* _SCREEN.ADDPROPERTY('sesB2T_Envelop',NEWOBJECT('form'))
 _SCREEN.ADDPROPERTY('frmB2T_Envelop',NEWOBJECT('frmInterface',lcx,''))
 RETURN
ENDFUNC &&Construct_Objects

FUNCTION Destruct_Objects	&&Internal. Removes FoxBin2PRG instance

*!*	<pdm>
*!*	<descr>Remove an instance of the business object of this application.</descr>
*!*	<copyright><i>&copy; 14.4.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 IF !PEMSTATUS(_SCREEN,'frmB2T_Envelop',5) THEN
  RETURN
 ENDIF &&!PEMSTATUS(_SCREEN,'frmB2T_Envelop',5)

 _SCREEN.frmB2T_Envelop = .NULL.
 REMOVEPROPERTY(_SCREEN,'frmB2T_Envelop')

ENDFUNC &&Destruct_Objects

*!*	/Changed by SF 11.4.2015

*!*	Changed by: SF 12.6.2015
*!*	<pdm>
*!*	<change date="{^2015-06-12,09:35:00}">Changed by: SF<br />
*!*	Added function to check if path is under git control and get git base dir
*!*	</change>
*!*	</pdm>

FUNCTION Is_git		&&Internal. Check if a directory is under git control
 LPARAMETERS;
  tcPath

*!*	<pdm>
*!*	<descr>Return if a directory is und git control.</descr>
*!*	<params name="tcPath" type="Character" byref="0" dir="" inb="0" outb="0">
*!*	<short>Path to investigate.</short>
*!*	<detail></detail>
*!*	</params>
*!*	<retval type="Boolean"><pdmpara num="1" /> is under git control.</retval>
*!*	<comment>
*!*	<remarks></remarks>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright><i>&copy; 12.6.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>
 LOCAL;
  llIs_git AS BOOLEAN

 llIs_git = !EMPTY(GetGitBaseDir(tcPath))
 _SCREEN.ADDPROPERTY('glB2T_gited',llIs_git)

 RETURN llIs_git
ENDFUNC &&Is_Git

FUNCTION GetGitBaseDir		&&Internal. Return git root directory
 LPARAMETERS;
  tcPath

*!*	<pdm>
*!*	<descr>Returns the git root directory of a given directory.</descr>
*!*	<params name="tcPath" type="Character" byref="0" dir="" inb="1" outb="1">
*!*	<short>Path to investigate.</short>
*!*	<detail>Default is <expr>FULLPATH(CURDIR())</expr></detail>
*!*	</params>
*!*	<retval type="Character">Root directory of <pdmpara num="1" />. Empty if <pdmpara num="1" /> is not under git control.</retval>
*!*	<comment>
*!*	<remarks></remarks>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright><i>&copy; 12.6.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 LOCAL;
  lcTemp   AS CHARACTER,;
  lc_Git   AS CHARACTER,;
  lcReturn AS CHARACTER

 lcReturn = ''

 IF VARTYPE(tcPath)#'C' THEN
  tcPath = FULLPATH(CURDIR())
 ENDIF &&VARTYPE(tcPath)#'C'


 IF Get_git_Path(@lc_Git) THEN

  lcTemp = FORCEPATH('git_x.tmp',tcPath)

  IF Run_ExtApp('cmd /c "'+lc_Git+'" rev-parse --show-toplevel>>git_x.tmp',tcPath,'HID') THEN
   IF FILE(lcTemp) THEN
    lcReturn = CHRTRAN(FILETOSTR(lcTemp),'/'+0h0d0a,'\')
   ENDIF &&FILE(lcTemp)
  ENDIF &&Run_ExtApp('cmd /c "'+_SCREEN.gcB2t_git+'" rev-parse --show-toplevel>>git_x.tmp',tcPath,'HID')

  DELETE FILE &lcTemp

 ENDIF &&Get_git_Path(@lc_git)

 RETURN lcReturn
ENDFUNC &&GetGitBaseDir
*!*	/Changed by: SF 12.6.2015

FUNCTION Get_git_Path &&Internal. Get installation status of git and path to binaries.
 LPARAMETERS;
  tc_git

*!*	<pdm>
*!*	<descr>Get installation status of git and paht to git binaries.</descr>
*!*	<params name="tc_git" type="Character" byref="1" dir="out" inb="0" outb="0">
*!*	<short>Path to git.exe.</short>
*!*	<detail>Includes git.exe</detail>
*!*	</params>
*!*	<retval type="Boolean">Path found</retval>
*!*	<remarks>Checks <i>HKLM\software\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1\</i>
*!*	for existence, returns the path out of <i>InstallLocation</i> value.</remarks>
*!*	<comment>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright><i>&copy; 14.9.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 #DEFINE ERROR_SUCCESS		0	&& OK
 #DEFINE HKEY_LOCAL_MACHINE          -2147483646  && BITSET(0,31)+2

 #DEFINE KEY_WOW64_64KEY 0x0100
 #DEFINE KEY_READ 0x20019

 LOCAL;
  llReturn AS BOOLEAN

 IF PEMSTATUS(_SCREEN,'gcB2T_git',5) THEN
*read from storage or set
  tc_git = _SCREEN.gcB2t_git
 ELSE  &&PEMSTATUS(_SCREEN,'gcB2T_git',5)
*try to read registry
  DECLARE INTEGER RegOpenKeyEx IN advapi32;
   INTEGER nHKey, STRING cSubKey, INTEGER ulOptions, INTEGER samDesired, INTEGER @nResult

  DECLARE INTEGER RegCloseKey IN Win32API ;
   INTEGER nHKey

  DECLARE INTEGER RegQueryValueEx IN Win32API ;
   INTEGER nHKey, STRING lpszValueName, INTEGER dwReserved,;
   INTEGER @lpdwType, STRING @lpbData, INTEGER @lpcbData

  LOCAL;
   lcReg    AS CHARACTER

  LOCAL;
   lnKey,;
   lnSubKey,;
   lpdwReserved,;
   lpdwType,;
   lpbData,;
   lpcbData,;
   lnErrCode AS INTEGER

*!*	Changed by: SF 1.12.2015
*!*	<pdm>
*!*	<change date="{^2015-12-01,11:30:00}">Changed by: SF<br />
*!*	use mulitple keys
*!*	</change>
*!*	</pdm>

  LOCAL ARRAY;
   laRegs(3,2)

  laRegs(1,1) = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1\"
  laRegs(1,2) = 'InstallLocation'
  laRegs(2,1) = "SOFTWARE\GitForWindows\"
  laRegs(2,2) = 'InstallPath'
  laRegs(3,1) = "SOFTWARE\WOW6432Node\GitForWindows\"
  laRegs(3,2) = 'InstallPath'


  FOR lnKey = 1 TO ALEN(laRegs,1)
   tc_git = ''
   STORE 0              TO lpdwReserved,lpdwType
   STORE SPACE(256)     TO lpbData
   STORE LEN(m.lpbData) TO lpcbData
   lnSubKey = 0
   lcReg = laRegs(lnKey,1)
   lnErrCode = RegOpenKeyEx(HKEY_LOCAL_MACHINE,m.lcReg,0,KEY_READ+KEY_WOW64_64KEY,@m.lnSubKey)
   IF m.lnErrCode=ERROR_SUCCESS THEN
*ReadKey
    m.lnErrCode=RegQueryValueEx(lnSubKey,laRegs(lnKey,2),;
     m.lpdwReserved,@lpdwType,@lpbData,@lpcbData)

* Check for error
    IF m.lnErrCode=ERROR_SUCCESS THEN
     tc_git = ADDBS(LEFT(m.lpbData,m.lpcbData-1))+'cmd\git.exe'
    ENDIF &&m.lnErrCode=ERROR_SUCCESS
*/ReadKey

*CloseKey
    =RegCloseKey(m.lnSubKey)
    lnSubKey = 0
*/CloseKey
   ENDIF &&m.lnErrCode=ERROR_SUCCESS
   IF FILE(m.tc_git) THEN
    EXIT
   ENDIF &&FILE(m.tc_git)
  ENDFOR &&lnKey

  lcReg = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1\"
*!*	/Changed by: SF 1.12.2015

  _SCREEN.ADDPROPERTY('gcB2T_git',IIF(FILE(m.tc_git),m.tc_git,''))

 ENDIF &&PEMSTATUS(_SCREEN,'gcB2T_git',5)

 llReturn = FILE(m.tc_git)

 RETURN m.llReturn
ENDFUNC &&Get_git_Path

*!*	Geändert durch: SF 4.6.2015
*!*	<pdm>
*!*	<change date="{^2015-06-04,11:20:00}">Geändert durch: SF<br />
*!*	Add output of curent git branch (if one exist)
*!*	</change>
*!*	</pdm>

PROCEDURE getbranch		&&Internal. Return active git branch

*!*	<pdm>
*!*	<descr>Output of current git branch</descr>
*!*	<retval type="Character">Branch, empty if no git active</retval>
*!*	<comment>
*!*	<remarks></remarks>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright><i>&copy; 4.6.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 LOCAL;
  lcRet AS CHARACTER,;
  lnSec AS NUMBER

 lcRet = ''
 IF Is_git() THEN
  IF Run_git('rev-parse --abbrev-ref HEAD>git_x.tmp',.F.,.T.) THEN
   lnSec = SECONDS()
*!*	   DO WHILE !FILE('git_x.tmp')
*!*	    WAIT "" WINDOW TIMEOUT 0.2
*!*	    IF SECONDS()-lnSec>=2 THEN
*!*	     EXIT
*!*	    ENDIF &&SECONDS()-lnSec>=2
*!*	   ENDDO &&!FILE('git_x.tmp')
   IF FILE('git_x.tmp') THEN
    lcRet = CHRTRAN(FILETOSTR('git_x.tmp'),0h0d0a,'')
    DELETE FILE git_x.tmp
   ENDIF &&FILE('git_x.tmp')
  ENDIF &&Run_git('rev-parse --abbrev-ref HEAD>git_x.tmp',.F.,.T.)
 ENDIF &&Is_git()

 RETURN lcRet
ENDPROC &&GetBranch
*!*	/Geändert durch: SF 4.6.2015

*!*	Changed by: SF 12.6.2015
*!*	<pdm>
*!*	<change date="{^2015-06-12,08:07:00}">Changed by SF<br />
*!*	Move git ShellExecute from <expr>RUN</expr> to API_AppRun
*!*	</change>
*!*	</pdm>

FUNCTION Run_git		&&Internal. Run a git root command
 LPARAMETERS;
  tcParameters,;
  tlShow,;
  tlIn_CMD

*!*	<pdm>
*!*	<descr>Run git program</descr>
*!*	<params name="tcParameters" type="Character" byref="0" dir="" inb="0" outb="0">
*!*	<short><parameters for git/short>
*!*	<detail></detail>
*!*	</params>
*!*	<params name="tlShow" type="Boolean" byref="0" dir="" inb="1" outb="0">
*!*	<short>Show command window>/short>
*!*	<detail></detail>
*!*	</params>
*!*	<params name="tlIn_CMD" type="Boolean" byref="0" dir="" inb="1" outb="0">
*!*	<short>Run command in CMD.>/short>
*!*	<detail>
*!*	<p>Some git commands like to be run in CMD, some dislike. Now we have a switch.</p>
*!*	<p>In general redirection of output (git status>xy.txt) needs CMD.</p>
*!*	</detail>
*!*	</params>
*!*	<remarks>Runs API_AppRun to run git.
* Uses <i>cmd</i> to perform piping operations.</remarks>
*!*	<retval type="Boolean">Success</retval>
*!*	<comment>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright><i>&copy; 17.9.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 LOCAL;
  lcPath   AS CHARACTER,;
  lc_Git   AS CHARACTER,;
  llReturn AS BOOLEAN

 lcPath = ADDBS(FULLPATH(CURDIR()))
*!*	Changed by: SF 17.9.2015
*!*	<pdm>
*!*	<change date="{^2015-09-17,04:43:00}">Changed by: SF<br />
*!*	switch between with CMD and without.
*!*	</change>
*!*	</pdm>

*rund cmd to perform piping data
 DO CASE
  CASE !Get_git_Path(@lc_Git)
*error, no git, not gitted
  CASE tlIn_CMD
   llReturn = Run_ExtApp('cmd /c "'+lc_Git+'" '+tcParameters,lcPath,IIF(tlShow,'NOR','HID'))
  OTHERWISE
   llReturn = Run_ExtApp('"'+lc_Git+'" '+tcParameters,lcPath,IIF(tlShow,'NOR','HID'))
 ENDCASE

*!*	/Changed by: SF 17.9.2015

 RETURN llReturn
ENDFUNC &&Run_git

*!*	Changed by: SF 15.9.2015
*!*	<pdm>
*!*	<change date="{^2015-09-15,08:21:00}">Changed by: SF<br />
*!*	new parameter for async working
*!*	</change>
*!*	</pdm>
FUNCTION Run_ExtApp		&&Internal. Run external app
 LPARAMETERS;
  tcCommandLine,;
  tcLaunchDir,;
  tcWindowMode,;
  tnExitCode,;
  tlNoWait

*!*	<pdm>
*!*	<descr>Run Ed Raus API_AppRun</descr>
*!*	<params name="tcCommandLine" type="Variant" byref="0" dir="" inb="0" outb="0">
*!*	<short>Command to run</short>
*!*	<detail></detail>
*!*	</params>
*!*	<params name="tcLaunchDir" type="Variant" byref="0" dir="" inb="0" outb="0">
*!*	<short>Path to run <pdmpara num="1" /> in.</short>
*!*	<detail></detail>
*!*	</params>
*!*	<params name="tcWindowMode" type="Variant" byref="0" dir="" inb="0" outb="0">
*!*	<short>Window Start Mode</short>
*!*	<detail>Window Start Mode, one of (HID, NOR, MIN, MAX) or empty
*defaults to empty, the default for the executable is used</detail>
*!*	</params>
*!*	<params name="tnExitCode" type="Variant" byref="1" dir="out" inb="1" outb="0">
*!*	<short>Exitcode of the app.</short>
*!*	<detail></detail>
*!*	</params>
*!*	<params name="tlNoWait" type="Boolean" byref="0" dir="out" inb="1" outb="0">
*!*	<short>Do not wait for external application.</short>
*!*	<detail></detail>
*!*	</params>
*!*	<retval type="Boolean">Success (<pdmpara num="4" /><expr>=0</expr>)</retval>
*!*	<comment>
*!*	<remarks></remarks>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright><i>&copy; 12.6.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 LOCAL;
  lcVCX AS CHARACTER,;
  loAPI AS "API_AppRun" OF "..\..\BIN2TEXT\LIBRARY\BIN_2_TEXT.VCX"

*for testing purposes
 lcVCX = 'e:\se\tools\bin2text\library\Bin_2_Text.vcx'
*runnning
* lcVCX = 'Bin_2_Text.vcx'

 loAPI = NEWOBJECT('API_AppRun',lcVCX,'',tcCommandLine,tcLaunchDir,tcWindowMode)
 tnExitCode = -1

 IF VARTYPE(loAPI)='O' AND !ISNULL(loAPI) THEN
  IF tlNoWait THEN
   IF loAPI.LaunchApp() THEN
    tnExitCode = NVL(loAPI.CheckProcessExitCode(),-1)
   ENDIF &&loAPI.LaunchApp()
  ELSE  &&tlNoWait
   IF loAPI.LaunchAppAndWait() THEN
    tnExitCode = NVL(loAPI.CheckProcessExitCode(),-1)
   ENDIF &&loAPI.LaunchAppAndWait()
  ENDIF &&tlNoWait
 ENDIF &&VARTYPE(loAPI)='O' AND !ISNULL(loAPI)

 loAPI = .NULL.

 RETURN tnExitCode=0

ENDFUNC &&Run_ExtApp
*!*	/Changed by: SF 15.9.2015
*!*	/Changed by SF 12.6.2015

FUNCTION HelpMsg	&&Internal. Display help message for external functions

 #DEFINE dcText_DE_H00;
  [Run:]+0h0d0a+;
  [DO Convert_Pjx IN RunB2T.prg]+" [OF Bin2Text.app]"+0h0d0a+;
  [ IDE Interface für FoxBin2Prg]+0h0D0A0D0A+;
  [DO Pjx2Commit IN RunB2T.prg]+" [OF Bin2Text.app]"+0h0d0a+;
  [ Wandle alle Dateien aller PJX im Verzeichnis nach Text]+0h0d0a+;
  [ und starte "git commit -a"]+0h0D0A0D0A+;
  [DO Inter_Active IN RunB2T.prg]+" [OF Bin2Text.app]"+0h0d0a+;
  [ Starte Einstellungsmaske.]+0h0D0A0D0A+;
  [DO InitMenu IN RunB2T.prg]+0h0d0a+;
  [ Starte Menü]+0h0D0A0D0A+;
  [DO Convert_Array IN RunB2T.prg]+" [OF Bin2Text.app]"+0h0d0a+;
  [ IDE Interface für FoxBin2Prg, für ein Datei Array]+0h0D0A0D0A+;

 #DEFINE dcText_DE_H01;
  "DO Convert_Pjx IN Bin2Text.app [[/?]|[lToBin[,nProjects[,nMode]]"+0h0d0a+;
  [ IDE Interface für FoxBin2Prg]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?        Zeigt diesen Hilfstext]+0h0d0a+;
  [  lToBin    Wenn wahr werden die Biärdateien erzeugt,]+0h0d0a+;
  [            sonst werden Textdateien erzeugt.(Default)]+0h0d0a+;
  [  nProjects Legt fest, welche Prokjekte werden einbezogen werden.]+0h0d0a+;
  [            0 Datei bestimmen (Default)]+0h0d0a+;
  [            1 aktives Projekt]+0h0d0a+;
  [            2 alle in der IDE aktiven Proejkte]+0h0d0a+;
  [            3 alle im Defaultpfad gefunden Projekte]+0h0d0a+;
  [  nMode     Legt fest, welcher Teil des Projektes gewandelt werden soll.]+0h0d0a+;
  [            die Quelldateien (VCX, FRX, ...) oder]+0h0d0a+;
  [            die Projekdateien (PJX)]+0h0d0a+;
  [            0 Quell-  und Projekdateien (Default)]+0h0d0a+;
  [            1 nur Quelldateien (VCX, FRX, ...)]+0h0d0a+;
  [            2 nur Projekdateien (PJX)]+0h0d0a+;
  [Alle Projekte werden temporär geschlossen.]+0h0d0a+;
  [Führt ein CLEAR ALL aus]

 #DEFINE dcText_DE_H02;
  "DO Convert_Pjx IN Bin2Text.app [/?]|[lToBin[,nProjects[,nMode]]]"+0h0d0a+;
  [Nur aus der IDE starten.]

 #DEFINE dcText_DE_H03;
  "DO Pjx2Commit IN Bin2Text.app [/?]|[lAll]"+0h0d0a+;
  [ Wandle alle Dateien aller PJX im Verzeichnis nach Text]+0h0d0a+;
  [ und starte "git add -A" + "git commit"]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?        Zeigt diesen Hilfstext]+0h0d0a+;
  [  lAll      Dateien die einzubeziehen sind]+0h0d0a+;
  [            .T. Alle Projekte im Pfad]+0h0d0a+;
  [            .F. Aktives Projekt (default)]

 #DEFINE dcText_DE_H04;
  "DO Pjx2Commit IN Bin2Text.app [/?]"+0h0D0A0D0A+;
  [Nur aus der IDE starten.]

 #DEFINE dcText_DE_H05;
  "DO InitMenu IN Bin2Text.app [/?]|[tcPath[,tlNoMenu]]"+0h0d0a+;
  [ Starte Menü]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?        Zeigt diesen Hilfstext]+0h0d0a+;
  [  tcPath    Pfad zur Einstellungsdatei.]+0h0d0a+;
  [  tlNoMenu  Starte das Menü nicht.]

 #DEFINE dcText_DE_H06;
  "DO InitMenu [/?]"+0h0D0A0D0A+;
  [Nur aus der IDE starten.]

 #DEFINE dcText_DE_H07;
  "DO Inter_Active IN Bin2Text.app [/?]"+0h0d0a+;
  [ Starte Einstllungsmaske.]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?        Zeigt diesen Hilfstext]

 #DEFINE dcText_DE_H08;
  "DO Inter_Active IN Bin2Text.app [/?]"+0h0D0A0D0A+;
  [Nur aus der IDE starten.]

 #DEFINE dcText_DE_H09;
  "DO Convert_Array IN Bin2Text.app [/?]|lToBin,cMode,@aFiles"+0h0d0a+;
  [ IDE interface for FoxBin2Prg, to be used with menu]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?        Zeigt diesen Hilfstext]+0h0d0a+;
  [  aFiles    Array mit Dateien]+0h0d0a+;
  [            Eine Spalte Datienamen mit pfad der Binärdatei]+0h0d0a+;
  [            Optionale zweite Spalte, wenn die erste in Projekt enthält den Projecthook]+0h0d0a+;
  [  lToBin    Wenn wahr werden die Biärdateien erzeugt,]+0h0d0a+;
  [            sonst werden Textdateien erzeugt.(Default)]+0h0d0a+;
  [  cMode     Modus für Projekt - Dateien.]+0h0d0a+;
  [            Optional in FoxBin2PRG Stil]+0h0d0a+;
  [            Wenn dieser Parameter nitch angegben ist werden pjx wie einfache Dateien behandelt]+0h0d0a+;
  [Classlibraries und Projecthooks werden nicht freigegeben.]

 #DEFINE dcText_DE_H10;
  "DO Convert_Array IN Bin2Text.app [/?]|lToBin,cMode,@aFiles"+0h0D0A0D0A+;
  [Nur aus der IDE starten.]
************************************************
 #DEFINE dcText_EN_H00;
  [Run:]+0h0d0a+;
  [DO Convert_Pjx IN Bin2Text.app]+0h0d0a+;
  [ IDE interface for FoxBin2Prg, to be used with menu]+0h0D0A0D0A+;
  [DO Pjx2Commit IN Bin2Text.app]+0h0d0a+;
  [ Process all containied in all PJX in Folder to text]+0h0d0a+;
  [ and run "git commit -a"]+0h0D0A0D0A+;
  [DO Inter_Active IN RunB2T.prg]+" [OF Bin2Text.app]"+0h0d0a+;
  [ Run settings form.]+0h0D0A0D0A+;
  [DO InitMenu IN RunB2T.prg]+0h0d0a+;
  [ Run menu]+0h0D0A0D0A+;
  [DO Convert_Array IN Bin2Text.app]+0h0d0a+;
  [ IDE interface for FoxBin2Prg, to be used an array of files.]

 #DEFINE dcText_EN_H01;
  "DO Convert_Pjx IN Bin2Text.app [/?]|[lToBin[,nProjects[,nMode]]"+0h0d0a+;
  [ IDE interface for FoxBin2Prg, to be used with menu]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?        This help message]+0h0d0a+;
  [  lToBin    If true, create binaries,]+0h0d0a+;
  [            if false create text files.(Default)]+0h0d0a+;
  [  nProjects Define which project to include.]+0h0d0a+;
  [            0 Select file interactive (Default)]+0h0d0a+;
  [            1 active project in IDE]+0h0d0a+;
  [            2 all projects open in IDE]+0h0d0a+;
  [            3 all projects in active path]+0h0d0a+;
  [  nMode     Mode of operation. Part of project to process]+0h0d0a+;
  [            source files (VCX, FRX, ...) or]+0h0d0a+;
  [            project files( (PJX)]+0h0d0a+;
  [            0 source-  and project files (Default)]+0h0d0a+;
  [            1 source files only (VCX, FRX, ...)]+0h0d0a+;
  [            2 project files only (PJX)]+0h0d0a+;
  [All projects will be closed temporary.]+0h0d0a+;
  [This will use CLEAR ALL!]

 #DEFINE dcText_EN_H02;
  "DO Convert_Pjx IN Bin2Text.app [/?]|[lToBin[,nProjects[,nMode]]]"+0h0D0A0D0A+;
  [Run from IDE only.]

 #DEFINE dcText_EN_H03;
  "DO Pjx2Commit IN Bin2Text.app [/?]|[lAll]"+0h0d0a+;
  [ Process all containied in all PJX in Folder to text]+0h0d0a+;
  [ and run "git add -A" + "git commit"]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?        This help message]+0h0d0a+;
  [  lAll      Process files]+0h0d0a+;
  [            .T. process all projects in path]+0h0d0a+;
  [            .F. process active project (default)]

 #DEFINE dcText_EN_H04;
  "DO Pjx2Commit IN Bin2Text.app [/?]"+0h0D0A0D0A+;
  [Run from IDE only.]

 #DEFINE dcText_EN_H05;
  "DO InitMenu IN Bin2Text.app [/?]|[tcPath[,tlNoMenu]]"+0h0d0a+;
  [ Run menu]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?        This help message]+0h0d0a+;
  [  tcPath    Path to the settings file.]+0h0d0a+;
  [  tlNoMenu  Do not start menu.]

 #DEFINE dcText_EN_H06;
  "DO InitMenu IN Bin2Text.app [/?]"+0h0D0A0D0A+;
  [Run from IDE only.]

 #DEFINE dcText_EN_H07;
  "DO Inter_Active IN Bin2Text.app [/?]"+0h0d0a+;
  [ Run settings form]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?        This help message]

 #DEFINE dcText_EN_H08;
  "DO Inter_Active IN Bin2Text.app [/?]"+0h0D0A0D0A+;
  [Run from IDE only.]

 #DEFINE dcText_EN_H09;
  "DO Convert_Array IN Bin2Text.app [/?]|lToBin,cMode,@aFiles"+0h0d0a+;
  [ IDE interface for FoxBin2Prg, to be used with menu]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?        This help message]+0h0d0a+;
  [  aFiles    Array with files]+0h0d0a+;
  [            One column, full qualified filename of binary]+0h0d0a+;
  [            Optional second column, if first colum is a project, projecthook.]+0h0d0a+;
  [  lToBin    If true, create binaries,]+0h0d0a+;
  [            if false create text files.(Default)]+0h0d0a+;
  [  cMode     Mode for project operation.]+0h0d0a+;
  [            Optional in FoxBin2PRG style]+0h0d0a+;
  [            If not set a pjx will run in just-a-file mode]+0h0d0a+;
  [This will not clear any CLASSLIB or free project hooks.]

 #DEFINE dcText_EN_H10;
  "DO Convert_Array IN Bin2Text.app [/?]|lToBin,cMode,@aFiles"+0h0D0A0D0A+;
  [Run from IDE only.]

 LPARAMETERS;
  tnHelp

*!*	<pdm>
*!*	<descr>Displays a help message.</descr>
*!*	<params name="tnHelp" type="Numeric" byref="0" dir="" inb="0" outb="0">
*!*	<short>Help number.</short>
*!*	<detail></detail>
*!*	</params>
*!*	<copyright><i>&copy; 14.4.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 _SCREEN.SHOW()
 _SCREEN.VISIBLE = .T.

 LOCAL;
  lcOut  AS CHARACTER,;
  lnMemo AS NUMBER

 DO CASE
  CASE tnHelp=01
   lcOut = dcText_EN_H01
  CASE tnHelp=02
   lcOut = dcText_EN_H02
  CASE tnHelp=03
   lcOut = dcText_EN_H03
  CASE tnHelp=04
   lcOut = dcText_EN_H04
  CASE tnHelp=05
   lcOut = dcText_EN_H05
  CASE tnHelp=06
   lcOut = dcText_EN_H06
  CASE tnHelp=07
   lcOut = dcText_EN_H07
  CASE tnHelp=08
   lcOut = dcText_EN_H08
  CASE tnHelp=09
   lcOut = dcText_EN_H09
  CASE tnHelp=10
   lcOut = dcText_EN_H10
  OTHERWISE
   lcOut = dcText_EN_H00
 ENDCASE

 lnMemo = SET("Memowidth")
 SET MEMOWIDTH TO 80
 ?lcOut FONT "Courier"
 SET MEMOWIDTH TO (lnMemo)
ENDFUNC &&HelpMsg

PROCEDURE CatchError		&&Error handler
 LPARAMETERS;
  tcProgram,;
  tnLineNo

*!*	<pdm>
*!*	<descr>Error Display. Cancel.</descr>
*!*	<params name="tcProgram" type="Character" byref="0" dir="" inb="0" outb="0">
*!*	<short>The usual stuff.</short>
*!*	<detail></detail>
*!*	</params>
*!*	<params name="lnLineNo" type="" byref="0" dir="" inb="0" outb="0">
*!*	<short>See <pdmpara num="1"/>.</short>
*!*	<detail></detail>
*!*	</params>
*!*	<copyright><i>&copy; 19.4.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 LOCAL ARRAY;
  laError(1,7)

 AERROR(laError)
 MESSAGEBOX('Error:'+PADL(laError(1,1),5)+', '+laError(1,2)+0h0d0a+;
  'Code block: '+tcProgram+0h0d0a+;
  'Code line: '+PADL(tnLineNo,7),;
  64,'Ooops, works not as expected.')
 SwitchErrorHandler()
 DEBUG
 SUSPEND
 RETRY
 CLEAR ALL
 CANCEL
ENDPROC &&CatchError

PROCEDURE SwitchErrorHandler		&&Toggle error handler
 LPARAMETERS;
  tlOn

*!*	<pdm>
*!*	<descr>Turn ErrorHandler on and off</descr>
*!*	<params name="tlOn" type="Boolean" byref="0" dir="" inb="0" outb="0">
*!*	<short>Turn errorhandling On</short>
*!*	<detail></detail>
*!*	</params>
*!*	<comment>
*!*	<retval type=""></retval>
*!*	<remarks></remarks>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright><i>&copy; 19.4.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 DO CASE
  CASE tlOn
   _SCREEN.ADDPROPERTY('gcB2T_Err',ON('Error'))
   ON ERROR DO CatchError WITH PROGRAM( ), LINENO( )
  CASE PEMSTATUS(_SCREEN,'gcB2T_Err',5)
   LOCAL;
    lcTemp
   lcTemp = _SCREEN.gcB2T_Err
   REMOVEPROPERTY(_SCREEN,'gcB2T_Err')
   ON ERROR &lcTemp
  OTHERWISE
   ON ERROR
 ENDCASE
ENDPROC &&SwitchErrorHandler

PROCEDURE ScanDir		&&Internal. Recursivly scan directories
 LPARAMETERS;
  tcDir,;
  tlToBin,;
  toConverter

*!*	<pdm>
*!*	<descr>Scan a directory recursive.</descr>
*!*	<params name="tcDir" type="Character" byref="0" dir="" inb="0" outb="0">
*!*	<short>Directory to scan</short>
*!*	<detail></detail>
*!*	</params>
*!*	<params name="tlToBin" type="Boolean" byref="0" dir="" inb="0" outb="0">
*!*	<short>Program will create binary codes from text</short>
*!*	<detail></detail>
*!*	</params>
*!*	<params name="toConverter" type="Object" byref="0" dir="" inb="0" outb="0">
*!*	<short>FoxBin2Text object to firure out settings of a given directory.</short>
*!*	<detail></detail>
*!*	</params>
*!*	<comment>
*!*	<retval type=""></retval>
*!*	<remarks></remarks>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright><i>&copy; 15.6.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 LOCAL;
  lnLoop1,;
  lcOldDir

 LOCAL ARRAY;
  laDir(1)

 lcOldDir = FULLPATH(CURDIR())
 CD (tcDir)
 FOR lnLoop1 = 1 TO ADIR(laDir,'','D')
  IF INLIST(laDir(lnLoop1,1),'.','..') THEN
   LOOP
  ENDIF &&INLIST(laDir(lnLoop1,1),'.','..')
  ScanDir(ADDBS(ADDBS(tcDir)+laDir(lnLoop1,1)),tlToBin,toConverter)
 ENDFOR &&lnLoop1
 Dir_Action(tcDir,tlToBin,toConverter)
 CD (lcOldDir)
ENDPROC &&ScanDir

PROCEDURE Dir_Action		&&Internal. Parse a directory for projcets (binary or text)
 LPARAMETERS;
  tcDir,;
  tlToBin,;
  toConverter

*!*	<pdm>
*!*	<descr>Scan a directory for project files (binary or text representation).</descr>
*!*	<params name="tcDir" type="Character" byref="0" dir="" inb="0" outb="0">
*!*	<short>Directory to scan</short>
*!*	<detail></detail>
*!*	</params>
*!*	<params name="tlToBin" type="Boolean" byref="0" dir="" inb="0" outb="0">
*!*	<short>Program will create binariy codes from text</short>
*!*	<detail></detail>
*!*	</params>
*!*	<params name="toConverter" type="Object" byref="0" dir="" inb="0" outb="0">
*!*	<short>FoxBin2Text object to firure out settings of a given directory.</short>
*!*	<detail></detail>
*!*	</params>
*!*	<comment>
*!*	<retval type=""></retval>
*!*	<remarks></remarks>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright><i>&copy; 15.6.2015 Lutz Scheffler Software Ingenieurbüro</i></copyright>
*!*	</pdm>

 LOCAL;
  lnProj      AS NUMBER,;
  lnProjs     AS NUMBER,;
  lnFiles     AS NUMBER,;
  lcSourceExt AS CHARACTER,;
  loConverter AS OBJECT,;
  loInfo      AS OBJECT

 LOCAL ARRAY;
  laFiles(1,1)

 IF tlToBin THEN
*get local text extension for project
  loInfo      = toConverter.Get_DirSettings(tcDir)
  lcSourceExt = loInfo.c_PJ2

 ELSE  &&tlToBin
  lcSourceExt = "PJX"
 ENDIF &&tlToBin

 loInfo      = .NULL.

 lnProjs = ADIR(laFiles,'*.'+lcSourceExt,'HS')

 IF lnProjs>0 THEN
  lnFiles = IIF(EMPTY(_SCREEN.gaFiles),0,ALEN(_SCREEN.gaFiles,1))

  DIMENSION;
   _SCREEN.gaFiles(lnFiles+lnProjs,2)

  FOR lnProj = 1 TO lnProjs
   _SCREEN.gaFiles(lnFiles+lnProj,1) = FORCEPATH(FORCEEXT(laFiles(lnProj,1),"PJX"),tcDir)
  ENDFOR &&lnProjs
 ENDIF &&lnProjs>0

ENDPROC &&Dir_Action
