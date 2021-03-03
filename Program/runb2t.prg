#INCLUDE STUFF.h
LPARAMETERS;
 tv01,tv02,tv03,tv04,tv05,tv06,tv07,tv08,;
 tv09,tv10,tv11,tv12,tv13,tv14,tv15,tv16,;
 tv17,tv18,tv19,tv20,tv21,tv22,tv23,tv24

LOCAL;
 loConverter

Construct_Objects()
IF _SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.) THEN
 SwitchErrorHandler(.F.)
 RETURN .F.
ENDIF &&_SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(@lcStorage,@loConverter,.T.)

*!*	<pdm>
*!*	<descr>Just an error catcher.</descr>
*!*	<params name="tv01, .., tv24" type="Variant" byref="0" dir="" inb="1" outb="0">
*!*	<short>Dummies</short>
*!*	<detail></detail>
*!*	</params>
*!*	<remarks>
*<p>
* This program stores functions to wrap Fernando D. Bozzo
* <a href="https://github.com/fdbozzo/foxbin2prg">FoxBin2Prg</a> for IDE purposes.
*</p>
*</remarks>
*!*
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 25.09.2019 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

SwitchErrorHandler(.T.)
HelpMsg(0)
SwitchErrorHandler(.F.)
?Is_git()
?GetBranch()
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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 05.6.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

*!*	<pdm>
*!*	<change date="{^2015-06-04,11:19:00}">Changed by: SF<br />
*!*	New parameter <pdmpara num="1" />
*!*	</change>

*!*	Changed by: SF 25.9.2019
*!*	<change date="{^2019-09-25,17:04:00}">Changed by: SF<br />
*!*	New way to deal with bash, switchable bash support.
*!*	</change>
*!*	</pdm>

 IF !VARTYPE(m.tlAll)='L' THEN
  HelpMsg(3)
  RETURN .F.
 ENDIF &&!VARTYPE(m.tlAll)='L'

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
  _SCREEN.frmB2T_Envelop.cusB2T.Storage_Close(m.lcStorage,.T.)
  Destruct_Objects()

  IF ISNULL(m.lcStorage) THEN
   SwitchErrorHandler(.F.)
   RETURN
  ENDIF &&ISNULL(m.lcStorage)
 ENDIF &&!PEMSTATUS(_SCREEN,"gcB2T_GitPjx",5)

 SwitchErrorHandler(.F.)
*DO Convert_Pjx IN (_SCREEN.gcB2T_App) WITH .F.,2,0
*DO Pjx2Commit IN (_SCREEN.gcB2T_App) WITH .T.
* IF Convert_Pjx(.F.,IIF(m.tlAll,3,1),ICASE(m.tlAll,0,_SCREEN.gcB2T_GitPjx="1",4,3)) THEN
 IF Convert_Pjx(.F.,IIF(m.tlAll,3,1),ICASE(m.tlAll,0,_SCREEN.gcB2T_GitPjx="1",4,3)) THEN
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
    lnSec       AS NUMBER,;
    lnErrorCode AS NUMBER,;
    llSuccess   AS BOOLEAN,;
    llIs64      AS BOOLEAN

   LOCAL;
    lcBat    AS CHARACTER,;
    lcPath   AS CHARACTER,;
    lcCommit AS CHARACTER,;
    lc_Git   AS CHARACTER

   Get_git_Path(@lc_Git,@llIs64)

   lcPath = ADDBS(FULLPATH(CURDIR()))
   IF !m.llIs64 AND (TYPE('_SCREEN.gcB2T_UseBash')="C" AND _SCREEN.gcB2T_UseBash=="1") THEN

    llSuccess = Run_git('add -A',,.F.,.F.,.F.)
*    llSuccess = m.llSuccess AND Run_git('status --porcelain>git_x.tmp',,.F.,.F.,.T.)
    = m.llSuccess AND Run_git('diff --cached --exit-code',,.F.,.F.,.F.,@lnErrorCode)
    llSuccess = m.llSuccess AND m.lnErrorCode=1  &&lnErrorCode -> files staged but not commited
   ELSE  &&!m.llIs64 AND (TYPE('_SCREEN.gcB2T_UseBash')="C" AND _SCREEN.gcB2T_UseBash=="1")

    TEXT TO lcBat NOSHOW TEXTMERGE
"<<m.lc_Git>>" add -A
"<<m.lc_Git>>" status --porcelain>git_x.tmp
    ENDTEXT &&lcBat
    STRTOFILE(m.lcBat,'git_x.bat')
    llSuccess = Run_ExtApp('cmd /c "'+m.lcPath+'git_x.bat"',JUSTPATH(m.lcPath),'HID')

    llSuccess = m.llSuccess AND FILE('git_x.tmp') AND LEN(FILETOSTR('git_x.tmp'))>0

    DELETE FILE git_x.*
   ENDIF &&!m.llIs64 AND (TYPE('_SCREEN.gcB2T_UseBash')="C" AND _SCREEN.gcB2T_UseBash=="1")

   IF m.llSuccess THEN
*!*	Changed by: SF 17.9.2015
*!*	<pdm>
*!*	<change date="{^2015-09-17,04:43:00}">Changed by: SF<br />
*!*	run git w/o CMD
*!*	</change>
*!*	</pdm>

    IF TYPE('_SCREEN.gcB2T_Commit')="C" AND _SCREEN.gcB2T_Commit=="1" THEN
     lcCommit = CHRTRAN(TTOC(DATETIME(),3),'T',' ')
     llSuccess = Run_git('commit -m "'+m.lcCommit+'" -m "auto-commit by RunB2T.app"',,.F.,.F.,.F.)
     IF m.llSuccess THEN
      ??' - auto commit '+m.lcCommit
     ELSE  &&m.llSuccess
      ?' commit failed'
     ENDIF &&m.llSuccess
    ELSE  &&TYPE('_SCREEN.gcB2T_Commit')="C" AND _SCREEN.gcB2T_Commit=="1"
     Run_git('commit',,.T.,.T.,.F.)
    ENDIF &&TYPE('_SCREEN.gcB2T_Commit')="C" AND _SCREEN.gcB2T_Commit=="1"
*!*	/Changed by: SF 17.9.2015
   ELSE  &&m.llSuccess
    ??' - nothing to commit'
   ENDIF &&m.llSuccess
*!*	/Changed by: SF 4.6.2015

  ELSE  &&Is_git()
   =MESSAGEBOX('Run "git init" to enable git.',0,'Bin2Text v'+dcB2T_Verno,10000)
  ENDIF &&Is_git()

  CD (_SCREEN.gcOld_Path)
  REMOVEPROPERTY(_SCREEN,'gcOld_Path')
  SwitchErrorHandler(.F.)

 ENDIF &&Convert_Pjx(.F.,IIF(m.tlAll,3,1),ICASE(m.tlAll,0,_SCREEN.gcB2T_GitPjx="1",4,3))
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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 14.4.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
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

*DO Convert_Pjx IN (_SCREEN.gcB2T_App) WITH .F.,2,0
*DO Pjx2Commit IN (_SCREEN.gcB2T_App) WITH .T.
* IF Convert_Pjx(.F.,IIF(m.tlAll,3,1),ICASE(m.tlAll,0,_SCREEN.gcB2T_GitPjx="1",4,3)) THEN
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
* <dt>1</dt><dd>Just the active project.</dd>
* <dt>2</dt><dd>All projects open in IDE. Include list of Additional Files from Settings interface.</dd>
* <dt>3</dt><dd>All projects in home path. Include list of Additional Files from Settings interface.</dd>
* <dt>4</dt><dd>All projects in home path, with subdirs. Include list of Additional Files from Settings interface.</dd>
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
*!*	<remarks>
*<p>For <pdmpar num="2" /> in 2,3,4 the list of Additional Files will not be processed, if there is no project found.</p>
*</remarks>
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 02.03.2021 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>

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
  CASE VARTYPE(m.tlToBin)#'L'
   tlToBin = '?'
  CASE VARTYPE(m.tnProjects)#'N'
   tnProjects = 0
  CASE !BETWEEN(m.tnProjects,0,4)
   tlToBin = '?'
  CASE VARTYPE(m.tnMode)#'N'
   tnProjects = 0
  CASE !BETWEEN(m.tnMode,0,4)
   tlToBin = '?'
  OTHERWISE
 ENDCASE

 lcOldExact = SET("Exact")
 SET EXACT ON
 IF VARTYPE(m.tlToBin)='C';
   AND INLIST(LOWER(m.tlToBin),'?','/?','-?','h','/h','-h','help','/help','-help') THEN

  HelpMsg(1)

  SET EXACT &lcOldExact
  RETURN .F.
 ENDIF &&VARTYPE(m.tlToBin)='C' AND INLIST(LOWER(m.tlToBin),'?','/?','-?','h','/h','-h','help','/help','-help')

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
  laProjects(m.lnProjs,3),;
  laFiles(1,2)

 CLEAR

 IF m.tlToBin THEN
  IF MESSAGEBOX('Create Binary?',4+32+256,'Bin2Text v'+dcB2T_Verno,10000)#6 THEN
   ?'Stopped by user'
   SwitchErrorHandler(.F.)
   RETURN .F.
  ENDIF &&MESSAGEBOX('Create Binary?',4+32+256,'FoxBin2Text',10000)#6
  ?'Process to binary'
 ELSE  &&m.tlToBin

  ?'Process to text'
 ENDIF &&m.tlToBin

 laProjects = .NULL.
 laFiles    = .NULL.

 lcOldPath  = FULLPATH(CURDIR())

 llCheckAll = !m.tlToBin
 DO CASE
  CASE m.tnProjects=0
*Getfile
   llCheckAll = .F.

   LOCAL;
    lcSourceExt AS CHARACTER

   IF m.tlToBin THEN
    LOCAL;
     loConverter AS OBJECT,;
     loInfo      AS OBJECT

    Construct_Objects()
    IF _SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.) THEN
     SwitchErrorHandler(.F.)
     RETURN .F.
    ENDIF &&_SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.)

*Just guess
    lcSourceExt = "PJ2"
   ELSE  &&m.tlToBin
    lcSourceExt = "PJX"
   ENDIF &&m.tlToBin

   lcPath = JUSTPATH(_SCREEN.gcB2T_Path)
   CD (m.lcPath)

   lcProj = GETFILE(m.lcSourceExt)

   IF !EMPTY(m.lcProj) AND m.tlToBin THEN
    lcPath = JUSTPATH(m.lcProj)

*get local text extension for project

    loInfo      = m.loConverter.Get_DirSettings(m.lcPath)
    lcSourceExt = UPPER(m.loInfo.c_PJ2)

    loInfo      = .NULL.
    loConverter = .NULL.
    Destruct_Objects()
   ENDIF &&!EMPTY(m.lcProj) AND m.tlToBin

   IF ISBLANK(m.lcProj) THEN
    CD (m.lcOldPath)
    ?'No project found'
    SwitchErrorHandler(.F.)
    RETURN .F.
   ENDIF &&!EMPTY(m.lcProj) AND ISBLANK(m.lcProj)

*!*	Changed by: SF 11.6.2015
*!*	<pdm>
*!*	<change date="{^2015-06-11,20:21:00}">Changed by: SF<br />
*!*	reworked wrong bracket
*!*	</change>
*!*	</pdm>

   IF m.tlToBin AND !UPPER(JUSTEXT(m.lcProj))==m.lcSourceExt THEN
*   IF m.tlToBin AND !UPPER(JUSTEXT(m.lcProj)==m.lcSourceExt) THEN
    MESSAGEBOX("File is not a valid text representation of a project in this folder",0,'Bin2Text v'+dcB2T_Verno)
    SwitchErrorHandler(.F.)
    RETURN .F.
   ENDIF &&m.tlToBin AND !UPPER(JUSTEXT(m.lcProj))==m.lcSourceExt

*!*	/Changed by: SF 11.6.2015

   lnProjs = 1
   _SCREEN.ADDPROPERTY('gaFiles(1,2)')
   _SCREEN.gaFiles(1,1) = FORCEEXT(m.lcProj,'PJX')
   _SCREEN.gaFiles(1,2) = ICASE(m.tnMode=3,"",m.tnMode=4,"",.NULL.)

   lcPath = JUSTPATH(m.lcProj)
   CD (m.lcPath)

*  &&m.tnProjects=0
  CASE m.tnProjects=1
*active project
   llCheckAll = .F.

   IF _VFP.PROJECTS.COUNT=0 THEN
    CD (m.lcOldPath)
    ?'No project found'
    SwitchErrorHandler(.F.)
    RETURN .F.
   ENDIF &&_VFP.PROJECTS.COUNT=0

   lnProjs = 1
   _SCREEN.ADDPROPERTY('gaFiles(1,2)')
   _SCREEN.gaFiles(1,1) = _VFP.ACTIVEPROJECT.NAME
   _SCREEN.gaFiles(1,2) = ICASE(m.tnMode=3,"",m.tnMode=4,"",_VFP.ACTIVEPROJECT.PROJECTHOOKLIBRARY)

   lcPath = JUSTPATH(_VFP.ACTIVEPROJECT.NAME)
   CD (m.lcPath)

*  &&m.tnProjects=1
  CASE m.tnProjects=2
*open projects
   llCheckAll = .F.

   lnProjs = _VFP.PROJECTS.COUNT
   IF m.lnProjs=0 THEN
    CD (m.lcOldPath)
    ?'No project found'
    SwitchErrorHandler(.F.)
    RETURN .F.
   ENDIF &&m.lnProjs=0

   _SCREEN.ADDPROPERTY('gaFiles('+TRIM(PADR(m.lnProjs,11))+',2)')

   lcPath = JUSTPATH(_VFP.ACTIVEPROJECT.NAME)
   CD (m.lcPath)

   lnProj     = 0
   FOR EACH loProject IN _VFP.PROJECTS FOXOBJECT
    lnProj = m.lnProj+1
    _SCREEN.gaFiles(m.lnProj,1) = m.loProject.NAME
    _SCREEN.gaFiles(m.lnProj,2) = ICASE(m.tnMode=3,"",m.tnMode=4,"",m.loProject.PROJECTHOOKLIBRARY)
   ENDFOR &&loProject

*  &&m.tnProjects=2
  CASE m.tnProjects=3
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
   ENDIF &&_SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.)

   lcPath = JUSTPATH(_SCREEN.gcB2T_Path)

   CD (m.lcPath)

   IF m.tlToBin THEN
*get local text extension for project
    loInfo      = m.loConverter.Get_DirSettings(m.lcPath)
    lcSourceExt = m.loInfo.c_PJ2

   ELSE  &&m.tlToBin
    lcSourceExt = "PJX"
   ENDIF &&m.tlToBin

   loInfo      = .NULL.
   loConverter = .NULL.
   Destruct_Objects()

   lnProjs = ADIR(laFiles,'*.'+m.lcSourceExt,'HS')

   IF m.lnProjs=0 THEN
    CD (m.lcOldPath)
    ?'No project found'
    SwitchErrorHandler(.F.)
    RETURN .F.
   ENDIF &&m.lnProjs=0

   _SCREEN.ADDPROPERTY('gaFiles('+TRIM(PADR(m.lnProjs,11))+',2)')

   FOR lnProj = 1 TO m.lnProjs
    _SCREEN.gaFiles(m.lnProj,1) = FORCEPATH(FORCEEXT(laFiles(m.lnProj,1),"PJX"),m.lcPath)
    _SCREEN.gaFiles(m.lnProj,2) = ICASE(m.tnMode=3,"",m.tnMode=4,"",.NULL.)
   ENDFOR &&lnProjs
*  &&m.tnProjects=3
  CASE m.tnProjects=4
*path, recursive
   LOCAL;
    lcSourceExt AS CHARACTER,;
    loConverter AS OBJECT

   Construct_Objects()
   IF _SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.) THEN
    SwitchErrorHandler(.F.)
    RETURN .F.
   ENDIF &&_SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.)

   lcPath = JUSTPATH(_SCREEN.gcB2T_Path)

   CD (m.lcPath)

   _SCREEN.ADDPROPERTY('gaFiles(1,2)')

   ScanDir(1,m.lcPath,m.tlToBin,m.loConverter)

   loConverter = .NULL.
   Destruct_Objects()

   lnProjs = IIF(EMPTY(_SCREEN.gaFiles),0,ALEN(_SCREEN.gaFiles,1))

   FOR lnProj = 1 TO m.lnProjs
    _SCREEN.gaFiles(m.lnProj,2) = ICASE(m.tnMode=3,"",m.tnMode=4,"",.NULL.)
   ENDFOR &&lnProjs
*  &&m.tnProjects=4
  OTHERWISE
   CD (m.lcOldPath)
   ?'Parameter not defined'
   SwitchErrorHandler(.F.)
   RETURN .F.
 ENDCASE

 DO CASE
  CASE m.tnMode=0
   lvMode     = "*"
   ??', generate projects and files of list'
  CASE m.tnMode=1
   llCheckAll = .F.
   lvMode     = "*-"
   ??', generate files list'
  CASE m.tnMode=2
   llCheckAll = .F.
   lvMode     = ""
   ??', generate projects'
  CASE m.tnMode=3
   llCheckAll = .F.
   lvMode     = "*-"
   ??', generate files list'
  CASE m.tnMode=4
   lvMode     = "*"
   ??', generate projects and files of list'
  OTHERWISE
   lvMode     = "*"
   ??', generate projects and files of list'
 ENDCASE

*close all the projects in the IDE / from StorePjx
*just to keep data over CLEAR ALL
 _SCREEN.ADDPROPERTY('gaProjects(1,2)')

 IF m.tnMode=3 THEN
*keep projects open, (do not parse hooks)
  _SCREEN.gaProjects = .NULL.
 ELSE  &&m.tnMode=3
  lnProjs = _VFP.PROJECTS.COUNT

  IF m.lnProjs=0 THEN
*nothing to do
   _SCREEN.gaProjects = .NULL.
   FOR lnProj = 1 TO m.lnProjs
    _SCREEN.gaFiles(m.lnProj,2) = "" && "no hook defined" -> no hook processed :)
   ENDFOR &&lnProjs
  ELSE  &&m.lnProjs=0
   DIMENSION;
    _SCREEN.gaProjects(m.lnProjs,2)

*!*	Changed by SF 12.5.2015
*!*	<pdm>
*!*	<change date="{^2015-05-12,11:36:00}">Changed by SF<br />
*!*	Make <expr>ACTIVEPROJECT</expr> active after reopen
*!*	</change>
*!*	</pdm>

*Active on top, to make it active on reopen
   lnProj = 1
   loProject = _VFP.ACTIVEPROJECT
   _SCREEN.gaProjects(m.lnProj,1) = m.loProject.NAME
*SF internal
   _SCREEN.gaProjects(m.lnProj,2) = VARTYPE(m.loProject.PROJECTHOOK)='O';
    AND !ISNULL(m.loProject.PROJECTHOOK);
    AND PEMSTATUS(m.loProject.PROJECTHOOK,'glCompileAll',5);
    AND m.loProject.PROJECTHOOK.glCompileAll
*/SF internal
   m.loProject.CLOSE

*   lnProj = 0

*!*	/Changed by SF 12.5.2015

   FOR EACH loProject IN _VFP.PROJECTS FOXOBJECT
*!*	Changed by: SF 7.12.2017
*!*	<pdm>
*!*	<change date="{^2017-12-07,14:10:00}">Changed by: SF<br />
*!*	Active project should not be added twice
*!*	</change>
*!*	</pdm>

    IF _SCREEN.gaProjects(1,1)==m.loProject.NAME THEN
     LOOP
    ENDIF &&_SCREEN.gaProjects(1,1)==m.loProject.NAME
    lnProj = m.lnProj+1
    _SCREEN.gaProjects(m.lnProj,1) = m.loProject.NAME
*SF internal
    _SCREEN.gaProjects(m.lnProj,2) = VARTYPE(m.loProject.PROJECTHOOK)='O';
     AND !ISNULL(m.loProject.PROJECTHOOK);
     AND PEMSTATUS(m.loProject.PROJECTHOOK,'glCompileAll',5);
     AND m.loProject.PROJECTHOOK.glCompileAll
*/SF internal
    m.loProject.CLOSE
   ENDFOR &&loProject
  ENDIF &&m.lnProjs=0
 ENDIF &&m.tnMode=3

*!*	Changed  by: SF 28.2.2021
*!*	<pdm>
*!*	<change date="{^2021-02-28,21:02:00}">Changed  by: SF<br />
*!*	Add List of files stored with settings.
*!*	</change>
*!*	</pdm>

 IF INLIST(m.tnProjects,2,3,4) THEN
  lvMode = m.lvMode+'-IncludeList'
 ENDIF &&INLIST(m.tnProjects,2,3,4)

*!*	/Changed  by: SF 28.2.2021



*just to keep data over CLEAR ALL
 _SCREEN.ADDPROPERTY('gcOld_Path',m.lcOldPath)
 _SCREEN.ADDPROPERTY('gvMode',m.lvMode)
 _SCREEN.ADDPROPERTY('glToBin',m.tlToBin)
 _SCREEN.ADDPROPERTY('glCheckAll',m.llCheckAll)

*to remove Classlibs so we can recreate
 CLEAR ALL

 LOCAL ARRAY;
  laFiles(1,1)

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

*reopen  all the projects in the IDE / from ReStorePjx
  lnProjs = ALEN(_SCREEN.gaProjects,1)
  FOR lnProj = m.lnProjs TO 1 STEP -1
   lcProj = _SCREEN.gaProjects(m.lnProj,1)
   IF !FILE(m.lcProj) THEN
    LOOP
   ENDIF &&!FILE(m.lcProj)

   llNotFound = .T.
   FOR EACH loProject IN _VFP.PROJECTS FOXOBJECT
    IF UPPER(JUSTSTEM(m.loProject.NAME))==m.lcProj THEN
     llNotFound = .F.
     EXIT
    ENDIF &&UPPER(JUSTSTEM(m.loProject.NAME))==m.lcProj
   ENDFOR &&loProject

   IF m.llNotFound THEN
    MODIFY PROJECT (m.lcProj) NOWAIT SAVE
    loProject = _VFP.ACTIVEPROJECT
    loProject.VISIBLE = .F.
    loProject.VISIBLE = .T.
*SF internal
    IF VARTYPE(m.loProject.PROJECTHOOK)='O';
      AND !ISNULL(m.loProject.PROJECTHOOK);
      AND PEMSTATUS(m.loProject.PROJECTHOOK,'glCompileAll',5) THEN
     loProject.PROJECTHOOK.glCompileAll = _SCREEN.gaProjects(m.lnProj,2)
    ENDIF &&VARTYPE(m.loProject.PROJECTHOOK)='O' AND !ISNULL(m.loProject.PROJECTHOOK) AND PEMSTATUS(m.loProject. ...
*/SF internal
   ENDIF &&m.llNotFound
  ENDFOR &&lnProj
 ENDIF &&!ISNULL(_SCREEN.gaProjects(1,1))

 REMOVEPROPERTY(_SCREEN,'gaProjects')

 CLEAR ALL

*!*	Changed by: SF 5.6.2015
*!*	<pdm>
*!*	<change date="{^2015-06-05,11:14:00}">Changed by: SF<br />
*!*	Output of current git branch
*!*	</change>
*!*	</pdm>
 lcProj = GetBranch()
 IF !EMPTY(m.lcProj) THEN
  ?'On branch '+m.lcProj
 ENDIF &&!EMPTY(m.lcProj)
*!*	/Changed by: SF 5.6.2015

 CD (_SCREEN.gcOld_Path)
 REMOVEPROPERTY(_SCREEN,'gcOld_Path')

 SwitchErrorHandler(.F.)
ENDFUNC &&Convert_Pjx

FUNCTION Convert_File  	&&Runs FoxBin2Prg for a single file or vcx/class.
 LPARAMETERS;
  tlToBin,;
  tlSingleClass

*!*	<pdm>
*!*	<descr>Runs FoxBin2Prg for a single file or class.</descr>
*!*	<params name="tlToBin" type="Boolean" byref="0" dir="" inb="0" outb="0">
*!*	<short>Direction of operation.</short>
*!*	<detail>
*<p>If true, create binaries from the text files corresponding <pdmpara num="2" />.</p>
*<p>If false create text files.(Default)</p>
*</detail>
*!*	<params name="tlSingleClass" type="Boolean" byref="0" dir="" inb="0" outb="0">
*!*	<short>Mode of file pickup, allows processing of single classes.</short>
*!*	<detail>
*<p>If true, pick up a single class via <expr>AGETCLASS()</expr>.</p>
*<p>If false, any source file.(Default)</p>
*<p>FoxBin2Prg will run in appropriate mode.</p>
*</detail>
*!*	</params>
*!*	<retval type="Boolean">Returns success of operation.</retval>
*!*	<remarks>
*<p>Runs a pickup for a file and transforms it.
*Will always transform, neither the file is changed or not.</p>
*<p>Picking a bin file for Text To Bin mode will select the txt file fitting.
*Same for selecting a class, it will process the classes text file if existing.</p>
*</remarks>
*!*	<comment>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 22.3.2017 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

 IF _VFP.STARTMODE#0 THEN
  HelpMsg(2)
  RETURN .F.
 ENDIF &&F_VFP.StartMode#0

 LOCAL;
  lcOldExact

 lcOldExact = SET("Exact")
 SET EXACT ON
 IF VARTYPE(m.tlToBin)='C';
   AND INLIST(LOWER(m.tlToBin),'?','/?','-?','h','/h','-h','help','/help','-help') THEN

  HelpMsg(11)

  SET EXACT &lcOldExact
  RETURN .F.
 ENDIF &&VARTYPE(m.tlToBin)='C' AND INLIST(LOWER(m.tlToBin),'?','/?','-?','h','/h','-h','help','/help','-help')

 SET EXACT &lcOldExact

 SwitchErrorHandler(.T.)

 LOCAL;
  lcPath AS STRING,;
  lcFileTypes,;
  lcFile,;
  lcSourceExt,;
  lvTemp,;
  llReturn,;
  loConverter AS OBJECT,;
  loInfo      AS OBJECT

 Construct_Objects()
 IF _SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.) THEN
  Destruct_Objects()
  SwitchErrorHandler(.F.)
  ?"Error"
  RETURN .F.
 ENDIF &&_SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.)

 lcPath = FULLPATH(CURDIR())

 loInfo      = m.loConverter.Get_DirSettings(m.lcPath)

 lcFileTypes = 'VCX;FRX;MNX;SCX;LBX;DBF;DBC'

 IF m.tlToBin THEN
  lvTemp = UPPER(m.loInfo.c_VC2)
  lcFileTypes = m.lcFileTypes+";*."+m.lvTemp+":"+m.lvTemp
  lvTemp = UPPER(m.loInfo.c_FR2)
  lcFileTypes = m.lcFileTypes+";*."+m.lvTemp+":"+m.lvTemp
  lvTemp = UPPER(m.loInfo.c_MN2)
  lcFileTypes = m.lcFileTypes+";*."+m.lvTemp+":"+m.lvTemp
  lvTemp = UPPER(m.loInfo.c_SC2)
  lcFileTypes = m.lcFileTypes+";*."+m.lvTemp+":"+m.lvTemp
  lvTemp = UPPER(m.loInfo.c_LB2)
  lcFileTypes = m.lcFileTypes+";*."+m.lvTemp+":"+m.lvTemp
  lvTemp = UPPER(m.loInfo.c_DB2)
  lcFileTypes = m.lcFileTypes+";*."+m.lvTemp+":"+m.lvTemp
  lvTemp = UPPER(m.loInfo.c_DC2)
  lcFileTypes = m.lcFileTypes+";*."+m.lvTemp+":"+m.lvTemp
 ENDIF &&m.tlToBin

 _SCREEN.ADDPROPERTY('glToBin',m.tlToBin)
 _SCREEN.ADDPROPERTY('gaProjects(1,3)')
 _SCREEN.ADDPROPERTY('gcSource',"")
 _SCREEN.ADDPROPERTY('gcTarget',"")
 _SCREEN.ADDPROPERTY('gcClass',"")
 _SCREEN.ADDPROPERTY('glSingleClass',"")
 _SCREEN.ADDPROPERTY('glInfo',.F.)

 STORE "" TO;
  _SCREEN.gaProjects

 IF m.tlToBin THEN
  lvTemp = "Convert To Bin"
 ELSE  &&m.tlToBin
  lvTemp = "Convert to Text"
 ENDIF &&m.tlToBin

 IF m.tlSingleClass THEN
  AGETCLASS(_SCREEN.gaProjects)	&&AGETCLASS(_SCREEN.gaProjects,'','',m.lvTemp) fails
  DIMENSION;
   _SCREEN.gaProjects(1,3)
 ELSE  &&m.tlSingleClass
  _SCREEN.gaProjects(1,1) = GETFILE(m.lcFileTypes,'','',0,m.lvTemp)
 ENDIF &&m.tlSingleClass

 llReturn = .T.

 IF m.llReturn AND EMPTY(_SCREEN.gaProjects(1,1)) THEN
*Nothing selected, GetFile cancled
*No Message
  llReturn = .F.
 ENDIF &&m.llReturn AND EMPTY(_SCREEN.gaProjects(1,1))

 loInfo      = m.loConverter.Get_DirSettings(JUSTPATH(_SCREEN.gaProjects(1,1)))

 IF m.llReturn AND INLIST(UPPER(JUSTEXT(_SCREEN.gaProjects(1,1))),'PJX',m.loInfo.c_PJ2) THEN
*no project here
  ?JUSTEXT(_SCREEN.gaProjects(1,1))+' file not allowed here.'
  llReturn = .F.
 ENDIF &&m.llReturn AND INLIST(UPPER(JUSTEXT(_SCREEN.gaProjects(1,1))),'PJX',m.loInfo.c_PJ2)

 IF m.llReturn THEN
* if to Bin
* if binary picked, need to figure out rules of textfile extension by path
* if SingleClass
* build up by rules
* fileformat
  IF m.tlToBin THEN

   lcSourceExt = UPPER(JUSTEXT(_SCREEN.gaProjects(1,1)))

*if binary file is send, gather text file extension
   DO CASE
*rethink this
*possibly protest / note on class picked from multi VC2
    CASE UPPER(m.lcSourceExt)=="VCX" AND m.tlSingleClass
     _SCREEN.gaProjects(1,3) = _SCREEN.gaProjects(1,1)
     lcSourceExt             = _SCREEN.gaProjects(1,2)+'.'+m.loInfo.c_VC2
    CASE UPPER(m.lcSourceExt)=="VCX"
     lcSourceExt = m.loInfo.c_VC2
    CASE UPPER(m.lcSourceExt)=="FRX"
     lcSourceExt = m.loInfo.c_FR2
    CASE UPPER(m.lcSourceExt)=="MNX"
     lcSourceExt = m.loInfo.c_MN2
    CASE UPPER(m.lcSourceExt)=="DBF"
     lcSourceExt = m.loInfo.c_DB2
    CASE UPPER(m.lcSourceExt)=="DBC"
     lcSourceExt = m.loInfo.c_DC2
    CASE UPPER(m.lcSourceExt)=="PJX"
     lcSourceExt = m.loInfo.c_PJ2
    CASE UPPER(m.lcSourceExt)=="LBX"
     lcSourceExt = m.loInfo.c_LB2
    CASE UPPER(m.lcSourceExt)=="SCX"
     lcSourceExt = m.loInfo.c_SC2
   ENDCASE

   _SCREEN.gaProjects(1,1) = FORCEEXT(_SCREEN.gaProjects(1,1),m.lcSourceExt)

   IF !FILE(_SCREEN.gaProjects(1,1)) THEN
    ?'File '+_SCREEN.gaProjects(1,1)+' not found.'
    llReturn = .F.
   ENDIF &&!FILE(_SCREEN.gaProjects(1,1))

   IF m.llReturn THEN
    IF MESSAGEBOX('Create Binary?',4+32+256,'Bin2Text v'+dcB2T_Verno,10000)#6 THEN
     ?'Stopped by user'
     llReturn = .F.
    ELSE &&MESSAGEBOX('Create Binary?',4+32+256,'Bin2Text v'+dcB2T_Verno,10000)#6
     ?'Process to binary'
    ENDIF &&MESSAGEBOX('Create Binary?',4+32+256,'Bin2Text v'+dcB2T_Verno,10000)#6
   ENDIF &&m.llReturn

   IF m.llReturn THEN
*SingleClass worker
*now the tricky thing
*do we process a single class to binary
*FoxBin2Prg is not very helpfull here
*so we need a kludge

*check if we pick a single class
*this is, the file should contain the classlib
*if the filename is different to classlib file, it's a single class

    lvTemp        = JUSTSTEM(LOWER(STREXTRACT(FILETOSTR(_SCREEN.gaProjects(1,1)),'SourceFile="','"',1)))
    tlSingleClass = !EMPTY(STRTRAN(LOWER(JUSTSTEM(_SCREEN.gaProjects(1,1))),m.lvTemp,''))
    IF m.tlSingleClass THEN
*now we need to work around
*see if we have a config file on files directory
*first we figure out the classes name

     lvTemp = JUSTEXT(JUSTSTEM(_SCREEN.gaProjects(1,1)))
     _SCREEN.gaProjects(1,1) = FORCEEXT(FORCEPATH(JUSTSTEM(JUSTSTEM(_SCREEN.gaProjects(1,1))),JUSTPATH(_SCREEN.gaProjects(1,1))),m.lcSourceExt)+;
      '::'+m.lvTemp+'::import'

    ENDIF &&m.tlSingleClass

*/SingleClass worker
   ENDIF &&m.llReturn


  ELSE &&m.tlToBin
   IF m.tlSingleClass THEN
    _SCREEN.gaProjects(1,1) = _SCREEN.gaProjects(1,1)+'::'+_SCREEN.gaProjects(1,2)+'::export'
    ?'Process to text'
   ENDIF &&m.tlSingleClass
  ENDIF &&m.tlToBin

 ENDIF &&m.llReturn

 _SCREEN.glInfo        = .T.
 _SCREEN.glSingleClass = m.tlSingleClass

 loInfo = .NULL.

 Destruct_Objects()

 IF m.llReturn THEN


  CLEAR ALL

*process Transformation
  Construct_Objects()

  LOCAL ARRAY;
   laFiles(1,1)

  ACOPY(_SCREEN.gaProjects,laFiles)

  LOCAL;
   llReturn,;
   loConverter AS OBJECT,;
   loInfo      AS OBJECT

  llReturn = .T.
******
  IF _SCREEN.glInfo THEN

   IF _SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.) THEN
    Destruct_Objects()
    SwitchErrorHandler(.F.)
    ?"Error"
    llReturn = .F.
   ENDIF &&_SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.)
   loInfo      = m.loConverter.Get_DirSettings(JUSTPATH(_SCREEN.gaProjects(1,1)))

   IF m.llReturn THEN
    loInfo.n_UseClassPerFile            = EVL(m.loInfo.n_UseClassPerFile,1)
    loInfo.l_ClassPerFileCheck          = .F.
    loInfo.l_RedirectClassPerFileToMain = .T.

    IF _SCREEN.glSingleClass THEN
     loInfo.n_RedirectClassType         = 1
    ELSE  &&_SCREEN.glSingleClass
     loInfo.n_RedirectClassType         = 0
    ENDIF &&_SCREEN.glSingleClass
   ENDIF &&m.llReturn
  ENDIF &&_SCREEN.glInfo
******

  llReturn = m.llReturn AND _SCREEN.frmB2T_Envelop.cusB2T.Process_Bin2Text(@laFiles,_SCREEN.glToBin,"",.F.,.T.,m.loInfo)

  loInfo = .NULL.

  Destruct_Objects()

 ENDIF &&m.llReturn

*!*	 REMOVEPROPERTY(_SCREEN,'gcCFG_File')
 REMOVEPROPERTY(_SCREEN,'glSingleClass')
 REMOVEPROPERTY(_SCREEN,'gcSource')
 REMOVEPROPERTY(_SCREEN,'gcTarget')
 REMOVEPROPERTY(_SCREEN,'gaProjects')
 REMOVEPROPERTY(_SCREEN,'glToBin')
 REMOVEPROPERTY(_SCREEN,'glInfo')

 SwitchErrorHandler(.F.)
 RETURN m.llReturn
ENDFUNC &&Convert_File

FUNCTION Convert_Directory  	&&Runs FoxBin2Prg for a single directory and it's sub directories.
 LPARAMETERS;
  tlToBin,;
  tcDirectory
*!*	<pdm>
*!*	<descr>Runs FoxBin2Prg for a directory.</descr>
*!*	<params name="tlToBin" type="Boolean" byref="0" dir="" inb="0" outb="0">
*!*	<short>Direction of operation.</short>
*!*	<detail>
*<p>If true, create binaries from the text files corresponding <pdmpara num="2" />.</p>
*<p>If false create text files.(Default)</p>
*</detail>
*!*	<params name="tcDirectory" type="Boolean" byref="0" dir="" inb="1" outb="1">
*!*	<short>Directories.</short>
*!*	<detail />
*!*	</params>
*!*	<retval type="Boolean">Returns success of operation.</retval>
*!*	<remarks>
*<p>Runs a pickup for a directory and transforms the files in it.
*Will always transform, neither the file is changed or not.</p>
*the files will be processed according to the setting of the config <i>foxbin2prg.cfg</i> file</p>
*</remarks>
*!*	<comment>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 12.02.2021 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

 IF _VFP.STARTMODE#0 THEN
  HelpMsg(2)
  RETURN .F.
 ENDIF &&F_VFP.StartMode#0

 LOCAL;
  lcOldExact

 lcOldExact = SET("Exact")
 SET EXACT ON
 IF VARTYPE(m.tlToBin)='C';
   AND INLIST(LOWER(m.tlToBin),'?','/?','-?','h','/h','-h','help','/help','-help') THEN

  HelpMsg(12)

  SET EXACT &lcOldExact
  RETURN .F.
 ENDIF &&VARTYPE(m.tlToBin)='C' AND INLIST(LOWER(m.tlToBin),'?','/?','-?','h','/h','-h','help','/help','-help')

 SET EXACT &lcOldExact

 SwitchErrorHandler(.T.)
 LOCAL;
  lcPath AS STRING,;
  lcFileTypes,;
  lcFile,;
  lcSourceExt,;
  lvTemp,;
  llReturn    AS BOOLEAN,;
  loConverter AS OBJECT,;
  loInfo      AS OBJECT

 Construct_Objects()
 IF _SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.) THEN
  Destruct_Objects()
  SwitchErrorHandler(.F.)
  ?"Error"
  RETURN .F.
 ENDIF &&_SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.)

 lcPath = FULLPATH(CURDIR())

 _SCREEN.ADDPROPERTY('glToBin',m.tlToBin)
 _SCREEN.ADDPROPERTY('glWithSub',m.tlWithSub)
 _SCREEN.ADDPROPERTY('gaFiles(1,2)')

 IF EMPTY(m.tcDirectory) OR !DIRECTORY(m.tcDirectory) THEN
  _SCREEN.gaFiles(1,1) = JUSTPATH(GETDIR(m.lcPath,'','',1+64))
 ELSE  &&EMPTY(m.tcDirectory) OR !DIRECTORY(m.tcDirectory)
  _SCREEN.gaFiles(1,1) = JUSTPATH(ADDBS(m.tcDirectory))
 ENDIF &&EMPTY(m.tcDirectory) OR !DIRECTORY(m.tcDirectory)

 llReturn = .T.

 IF m.llReturn THEN
  IF m.tlToBin THEN
   IF MESSAGEBOX('Create Binary?',4+32+256,'Bin2Text v'+dcB2T_Verno,10000)#6 THEN
    ?'Stopped by user'
    llReturn = .F.
   ELSE &&MESSAGEBOX('Create Binary?',4+32+256,'Bin2Text v'+dcB2T_Verno,10000)#6
    ?'Process to binary - no storage operation'
   ENDIF &&MESSAGEBOX('Create Binary?',4+32+256,'Bin2Text v'+dcB2T_Verno,10000)#6
  ELSE  &&m.tlToBin
   ?'Process to text - no storage operation'
  ENDIF &&m.tlToBin
 ENDIF &&m.llReturn

 IF m.llReturn AND EMPTY(_SCREEN.gaFiles(1,1)) THEN
*Nothing selected, GetDir cancled
*No Message
  llReturn = .F.
 ENDIF &&m.llReturn AND EMPTY(_SCREEN.gaFiles(1,1))

* loInfo      = m.loConverter.Get_DirSettings(JUSTPATH(_SCREEN.gaFiles(1,1)))
 Destruct_Objects()

 IF m.llReturn THEN
  CLEAR ALL

*process Transformation
  Construct_Objects()

  LOCAL;
   llReturn,;
   loConverter AS OBJECT,;
   loInfo      AS OBJECT

  llReturn = .T.

  IF _SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.) THEN
   Destruct_Objects()
   SwitchErrorHandler(.F.)
   ?"Error"
   llReturn = .F.
  ENDIF &&_SCREEN.frmB2T_Envelop.cusB2T.Get_Converter(,@loConverter,.T.)

  IF m.llReturn THEN

   LOCAL ARRAY;
    laFiles(ALEN(_SCREEN.gaFiles,1),1)

   ACOPY(_SCREEN.gaFiles,laFiles)

   llReturn = m.llReturn AND _SCREEN.frmB2T_Envelop.cusB2T.Process_Dir_Bin2Text(@laFiles,_SCREEN.glToBin)

   loInfo = .NULL.

  ENDIF &&m.llReturn

  Destruct_Objects()
 ENDIF &&m.llReturn

********
 REMOVEPROPERTY(_SCREEN,'gaFiles')
 REMOVEPROPERTY(_SCREEN,'glWithSub')
 REMOVEPROPERTY(_SCREEN,'glToBin')

 SwitchErrorHandler(.F.)
 RETURN m.llReturn
ENDFUNC &&Convert_Directory

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
* <p>One column, full qualified filename of binary. or text.
* If <pdmpara num="1" /> is <expr>false</expr>, the column can declare a class in form <i>File<b>::Class</b></i>
* as used by FoxBin2Prg for libraries.</p>
* <p>Optional second column, if first column is a project, projecthook.</p>
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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 23.3.2017 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
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
  CASE VARTYPE(m.tlToBin)#'L'
   tlToBin = '?'
  CASE VARTYPE(m.tcMode)#'C'
   tlToBin = '?'
  CASE TYPE('ALEN(taFiles)')#'N'
   tlToBin = '?'
  OTHERWISE
   LOCAL;
    lnLoop

   FOR lnLoop = 1 TO ALEN(taFiles)
    IF !TYPE(taFiles(m.lnLoop,1))='C' THEN
     tlToBin = '?'
     EXIT
    ENDIF &&!TYPE(taFiles(m.lnLoop,1))='C'
   ENDFOR &&lnLoop
   IF !VARTYPE(m.tlToBin)='C' AND ALEN(taFiles,2)>1 THEN
    FOR lnLoop = 1 TO ALEN(taFiles)
     IF !TYPE(taFiles(m.lnLoop,2))='C' OR ISNULL(taFiles(m.lnLoop,2)) THEN
      tlToBin = '?'
      EXIT
     ENDIF &&!TYPE(taFiles(m.lnLoop,2))='C' OR ISNULL(taFiles(m.lnLoop,2))
    ENDFOR &&lnLoop
   ENDIF &&!VARTYPE(m.tlToBin)='C' AND ALEN(taFiles,2)>1
 ENDCASE

 IF VARTYPE(m.tlToBin)='C';
   AND INLIST(LOWER(m.tlToBin),'?','/?','-?','h','/h','-h','help','/help','-help') THEN
  HelpMsg(1)
  RETURN .F.
 ENDIF &&VARTYPE(m.tlToBin)='C' AND INLIST(LOWER(m.tlToBin),'?','/?','-?','h','/h','-h','help','/help','-help')

 SwitchErrorHandler(.T.)
*process Transformation
 Construct_Objects()
 _SCREEN.frmB2T_Envelop.cusB2T.Process_Bin2Text(@taFiles,m.tlToBin,m.tcMode)
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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 14.4.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

 LOCAL;
  lcOldExact	AS STRING
 IF _VFP.STARTMODE#0 THEN
  HelpMsg(6)
  RETURN .F.
 ENDIF &&F_VFP.StartMode#0

 DO CASE
  CASE PCOUNT()=0
  CASE VARTYPE(m.tcHomePath)#'C'
   tcHomePath = '?'
  CASE PCOUNT()=1
  CASE VARTYPE(m.tlNoMenu)#'L'
   tcHomePath = '?'
  OTHERWISE
 ENDCASE

 lcOldExact = SET("Exact")
 SET EXACT ON
 IF VARTYPE(m.tcHomePath)='C';
   AND INLIST(LOWER(m.tcHomePath),'?','/?','-?','h','/h','-h','help','/help','-help') THEN

  HelpMsg(5)

  SET EXACT &lcOldExact
  RETURN .F.
 ENDIF &&VARTYPE(m.tcHomePath)='C' AND INLIST(LOWER(m.tcHomePath),'?','/?','-?','h','/h','-h','help','/help','-help')

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
  lcProc AS CHARACTER,;
  lcFile AS CHARACTER,;
  lcMenu AS CHARACTER,;
  lcPath AS CHARACTER,;
  lnLoop AS INTEGER

 LOCAL ARRAY;
  laDirs(1)

 lcMenu = ""

 Construct_Objects()

 lcFile = _SCREEN.frmB2T_Envelop.cusB2T.Storage_Check(.F.,m.tcHomePath)
 IF ISNULL(m.lcFile) THEN
  ?"Failed to init FoxBin2Prg IDE integration."
 ELSE  &&ISNULL(m.lcFile)

  _SCREEN.frmB2T_Envelop.cusB2T.Storage_Close(m.lcFile,.T.)
  IF !m.tlNoMenu THEN

   lnLoop = 1
   lcFile = SYS(16,m.lnLoop)
   DO WHILE LEN(m.lcFile)>0
    lnLoop = m.lnLoop+1
    lcProc = STREXTRACT(m.lcFile,' ',' ',1)
    lcFile = STREXTRACT(m.lcFile,' ',' ',2,2)

    IF UPPER(m.lcProc)=="INITMENU";
      OR UPPER(JUSTFNAME(m.lcFile))=="BIN2TEXT.APP" THEN

     ADDPROPERTY(_SCREEN,'gcB2T_App',m.lcFile)

     lcPath = UPPER(JUSTPATH(m.lcFile))

     lcMenu = "Bin2Text.mpr"
     IF LEN(SET("Path"))#0 THEN
*check VFP path to figure out if we are within
      FOR lnLoop = 1 TO ALINES(laDirs,SET("Path"),';')
       IF m.lcPath==UPPER(m.laDirs(m.lnLoop)) THEN
        lcPath = ""
        EXIT
       ENDIF &&m.lcPath==UPPER(laDirs(m.lnLoop))
      ENDFOR &&lnLoop
      IF !EMPTY(m.lcPath) THEN
       lcPath = m.lcPath+';'+SET("Path")
      ENDIF &&!EMPTY(m.lcPath)
     ENDIF &&LEN(SET("Path"))#0

     IF !EMPTY(m.lcPath) THEN
      SET PATH TO (m.lcPath)
     ENDIF &&!EMPTY(m.lcPath)

     EXIT
    ENDIF &&UPPER(m.lcProc)=="INITMENU" OR UPPER(JUSTFNAME(m.lcFile))=="BIN2TEXT.APP"

    lcFile = SYS(16,m.lnLoop)
   ENDDO &&LEN(m.lcFile)>0


   IF !EMPTY(m.lcMenu) THEN
    DO (m.lcMenu)
   ENDIF &&!EMPTY(m.lcMenu)

  ENDIF &&!m.tlNoMenu
 ENDIF &&ISNULL(m.lcFile)
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
*!*	<descr>Run <i>git bash</i> for current project in git based irectory.</descr>
*!*	<comment>
*!*	<remarks>This is experimental. <i>git bash</i> works not as expected.</remarks>
*!*	<retval type=""></retval>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 14.3.2016 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

*!*	Changed by: SF 14.3.2016
*!*	<pdm>
*!*	<change date="{^2016-03-14,10:56:00}">Changed by: SF<br />
*!*	Git bash starts in git base directory. Uses location of active project, if no project, the current path.
*!* If not under git control at all, location of active project or current path.
*!*	</change>
*!*	</pdm>

 LOCAL;
  lc_Git AS CHARACTER,;
  llIs64 AS BOOLEAN

 IF Get_git_Path(@lc_Git,@llIs64) THEN
  LOCAL;
   lcOldPath AS CHARACTER,;
   lcPath    AS CHARACTER

  lcOldPath = JUSTPATH(FULLPATH(CURDIR()))
  lcPath    = GetBaseDir()

  CD (m.lcPath)

*!*	Changed by: SF 5.1.2016
*!*	<pdm>
*!*	<change date="{^2016-01-05,12:50:00}">Changed by: SF<br />
*!*	Better call for git bash without additional windows.
*!*	</change>
*!*	<change date="{^2019-09-25,17:00:00}">Changed by: SF<br />
*!*	Reworked call for bash.
*!*	</change>
*!*	</pdm>

  IF TYPE('_SCREEN.gcB2T_UseBash')="C" AND _SCREEN.gcB2T_UseBash=="1" THEN
   llReturn = Run_ExtApp('"'+FORCEPATH('git-bash.exe',JUSTPATH(JUSTPATH(m.lc_Git)))+'" ',m.lcPath,'NOR',,.T.)
  ELSE  &&TYPE('_SCREEN.gcB2T_UseBash')="C" AND _SCREEN.gcB2T_UseBash=="1"
   llReturn = Run_ExtApp('cmd',m.lcPath,'NOR',,.T.)
  ENDIF &&TYPE('_SCREEN.gcB2T_UseBash')="C" AND _SCREEN.gcB2T_UseBash=="1"

  CD (m.lcOldPath)

*!*	/Changed by: SF 5.1.2016
 ENDIF &&Get_git_Path(@lc_Git,@llIs64)

*!*	/Changed by: SF 14.3.2016
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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 15.9.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

*!*	changed by SF 25.9.2019
*!*	<pdm>
*!*	<change date="{^2019-09-25,08:35:00}">changed by SF<br />
*!*	Run selectable GUI instead of gitk
*!*	</change>
*!*	</pdm>

 LOCAL;
  lcPath AS CHARACTER

 lcPath = JUSTPATH(FULLPATH(CURDIR()))

 IF Is_git() THEN
  llReturn = Run_ExtApp('"'+_SCREEN.gcB2T_GUI+'" ',m.lcPath,'NOR',,.T.)
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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 14.4.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

 IF PEMSTATUS(_SCREEN,'frmB2T_Envelop',5) AND !ISNULL(_SCREEN.frmB2T_Envelop) THEN
  RETURN
 ENDIF &&PEMSTATUS(_SCREEN,'frmB2T_Envelop',5) AND !ISNULL(_SCREEN.frmB2T_Envelop)

*runnning
 lcx = 'Bin_2_Text.vcx'

* _SCREEN.ADDPROPERTY('sesB2T_Envelop',NEWOBJECT('form'))
 _SCREEN.ADDPROPERTY('frmB2T_Envelop',NEWOBJECT('frmInterface',lcx,''))
 RETURN
ENDFUNC &&Construct_Objects

FUNCTION Destruct_Objects	&&Internal. Removes FoxBin2PRG instance

*!*	<pdm>
*!*	<descr>Remove an instance of the business object of this application.</descr>
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 14.4.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 12.6.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>
 LOCAL;
  llIs_git AS BOOLEAN

 llIs_git = !EMPTY(GetGitBaseDir(m.tcPath))
 _SCREEN.ADDPROPERTY('glB2T_gited',m.llIs_git)

 RETURN m.llIs_git
ENDFUNC &&Is_Git

PROCEDURE Print_ActiveBranch
*!*	<pdm>
*!*	<!-- <descr>Print the active branch to _SCREEN</descr> -->
*!*	<comment>
*!*	<retval type=""></retval>
*!*	<remarks></remarks>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 8.11.2017 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

 IF Is_git() THEN
  ?'On branch '+GetBranch()
 ENDIF &&Is_Git()
ENDPROC &&Print_ActiveBranch


FUNCTION GetBaseDir		&&Internal. Return base directory
*!*	<pdm>
*!*	<descr>Returns the git root directory of a given directory.</descr>
*!*	<retval type="Character">
*!*	Root directory of <expr>_VFP.ACTIVEPROJECT</expr>.<br />
*!*	If no project open root directory of current directory,<br />
*!*	If not under git control directory of <expr>_VFP.ACTIVEPROJECT</expr>, if no project opn current directory.
*!*	</retval>
*!*	<comment>
*!*	<remarks></remarks>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 12..201 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

*!*	SF Changed by 12.2.2021
*!*	<pdm>
*!*	<change date="{^2021-02-12,08:27:00}">SF Changed by<br />
*!*	Removed trailing backslash, confused Run_ExtApp
*!*	</change>
*!*	</pdm>

 LOCAL;
  lcReturn AS CHARACTER

 lcReturn = JUSTPATH(IIF(_VFP.PROJECTS.COUNT>0,_VFP.ACTIVEPROJECT.NAME,FULLPATH(CURDIR())))
 lcReturn = EVL(GetGitBaseDir(),m.lcReturn)

 RETURN m.lcReturn
ENDFUNC &&GetBaseDir

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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 16.6.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

 LOCAL;
  lcTemp   AS CHARACTER,;
  lc_Git   AS CHARACTER,;
  lcReturn AS CHARACTER,;
  llIs64   AS BOOLEAN

 lcReturn = ''

 DO CASE
  CASE VARTYPE(m.tcPath)#'C' OR EMPTY(m.tcPath)
   tcPath = JUSTPATH(FULLPATH(CURDIR()))
  CASE EMPTY(m.tcPath)
   tcPath = JUSTPATH(FULLPATH(CURDIR()))
  OTHERWISE
   tcPath = JUSTPATH(ADDBS(m.tcPath))
 ENDCASE

 lcTemp = FORCEPATH('git_x.tmp',m.tcPath)

 IF Run_git('rev-parse --show-toplevel>git_x.tmp',m.tcPath,.F.,.F.) THEN

  IF FILE(m.lcTemp) THEN
   lcReturn = CHRTRAN(FILETOSTR(m.lcTemp),'/'+0h0d0a,'\')
  ELSE &&FILE(m.lcTemp)

   IF Get_git_Path(@lc_Git,@llIs64) THEN

    lcTemp = FORCEPATH('git_x.tmp',m.tcPath)
    IF Run_ExtApp('cmd /c ""'+m.lc_Git+'" rev-parse --show-toplevel>git_x.tmp'+'"',m.tcPath,'HID') THEN
     IF FILE(m.lcTemp) THEN
      lcReturn = CHRTRAN(FILETOSTR(m.lcTemp),'/'+0h0d0a,'\')
     ENDIF &&FILE(m.lcTemp)
    ENDIF &&Run_ExtApp('cmd /c ""'+m.lc_Git+'" rev-parse --show-toplevel>git_x.tmp'+'"',m.tcPath,'HID')
   ENDIF &&Get_git_Path(@lc_Git,@llIs64)

  ENDIF &&FILE(m.lcTemp)
 ENDIF &&Run_git('rev-parse --show-toplevel>git_x.tmp',m.tcPath,.F.,.F.)

 DELETE FILE &lcTemp

* ENDIF &&Get_git_Path(@lc_Git,@llIs64)

 RETURN m.lcReturn
ENDFUNC &&GetGitBaseDir
*!*	/Changed by: SF 12.6.2015

FUNCTION Get_git_Path &&Internal. Get installation status of git and path to binaries.
 LPARAMETERS;
  tc_git,;
  tlIs64

*!*	<pdm>
*!*	<descr>Get installation status of git and paht to git binaries.</descr>
*!*	<params name="tc_git" type="Character" byref="1" dir="out" inb="0" outb="0">
*!*	<short>Path to git.exe.</short>
*!*	<detail>Includes git.exe</detail>
*!*	</params>
*!*	<params name="tlIs64" type="Character" byref="1" dir="out" inb="1" outb="1">
*!*	<short>Is 64bit git installed.</short>
*!*	<detail>Checks if 64bit is installed. 64bit needs different calling then 32bit, because VFP is 32bit.</detail>
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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 11.2.2021 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

*!*	SF Changed by 11.2.2021
*!*	<pdm>
*!*	<change date="{^2021-02-11,12:55:00}">SF Changed by<br />
*!*	Added code to determine 64 or 32 bit git,<br />
*!*	Find git on per-user-install<br />
*!*	Removed obolete place to look for git.<br />
*!*	</change>
*!*	</pdm>

 #DEFINE ERROR_SUCCESS		0	&& OK
 #DEFINE HKEY_CURRENT_USER           -2147483647  && BITSET(0,31)+1
 #DEFINE HKEY_LOCAL_MACHINE          -2147483646  && BITSET(0,31)+2

 #DEFINE KEY_WOW64_64KEY 0x0100
 #DEFINE KEY_READ 0x20019

 LOCAL;
  llReturn AS BOOLEAN

 IF PEMSTATUS(_SCREEN,'gcB2T_git',5) THEN
*read from storage or set
  tc_git = _SCREEN.gcB2T_git
  tlIs64 = _SCREEN.glB2T_git64

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
   lnNode,;
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
   laRegs(3,4)
* Col 1, Node
* Col 2, Key
* Col 3, Value
* Col 4, Boolean, 64 bit oder Value um dies zu ermitteln

  laRegs(1,1) = HKEY_LOCAL_MACHINE
  laRegs(1,2) = "SOFTWARE\GitForWindows\"	&&64
  laRegs(1,3) = 'InstallPath'
  laRegs(1,4) = .T.
  laRegs(2,1) = HKEY_LOCAL_MACHINE
  laRegs(2,2) = "SOFTWARE\WOW6432Node\GitForWindows\"		&&32
  laRegs(2,3) = 'InstallPath'
  laRegs(2,4) = .F.
  laRegs(3,1) = HKEY_CURRENT_USER
  laRegs(3,2) = "SOFTWARE\GitForWindows\"		&&32/64
  laRegs(3,3) = 'InstallPath'
  laRegs(3,4) = 'LibexecPath'
* Wert kann zwischen 64 und 32 bit unterscheiden
* 64 LibexecPath:  %LOCALAPPDATA%\Programs\Git\mingw64\libexec\Git-core
* 32 LibexecPath:  %LOCALAPPDATA%\\Programs\Git\mingw32\libexec\Git-core

  FOR lnKey = 1 TO ALEN(laRegs,1)
   tc_git = ''
   tlIs64 = .F.

   STORE 0              TO lpdwReserved,lpdwType
   STORE SPACE(256)     TO lpbData
   STORE LEN(m.lpbData) TO lpcbData
   lnSubKey = 0
   lnNode = laRegs(m.lnKey,1)
   lcReg  = laRegs(m.lnKey,2)
   lnErrCode = RegOpenKeyEx(m.lnNode,m.lcReg,0,KEY_READ+KEY_WOW64_64KEY,@lnSubKey)
   IF m.lnErrCode=ERROR_SUCCESS THEN
*ReadKey
    m.lnErrCode=RegQueryValueEx(m.lnSubKey,laRegs(m.lnKey,3),;
     m.lpdwReserved,@lpdwType,@lpbData,@lpcbData)

* Check for error
    IF m.lnErrCode=ERROR_SUCCESS THEN
     tc_git = ADDBS(LEFT(m.lpbData,m.lpcbData-1))+'cmd\git.exe'

     IF VARTYPE(laRegs(m.lnKey,4))='L' THEN
      tlIs64 = laRegs(m.lnKey,4)
     ELSE  &&VARTYPE(laRegs(m.lnKey,4))='L'
      STORE 0              TO lpdwReserved,lpdwType
      STORE SPACE(256)     TO lpbData
      STORE LEN(m.lpbData) TO lpcbData
*     ReadKey
      m.lnErrCode=RegQueryValueEx(m.lnSubKey,laRegs(m.lnKey,4),;
       m.lpdwReserved,@lpdwType,@lpbData,@lpcbData)

      IF m.lnErrCode=ERROR_SUCCESS THEN
       tlIs64 = '\mingw64\'$LEFT(m.lpbData,m.lpcbData-1)
      ENDIF &&m.lnErrCode=ERROR_SUCCESS
*     /ReadKey
     ENDIF &&VARTYPE(laRegs(m.lnKey,4))='L'
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

*!*	/Changed by: SF 1.12.2015

  _SCREEN.ADDPROPERTY('gcB2T_git',IIF(FILE(m.tc_git),m.tc_git,''))
  _SCREEN.ADDPROPERTY('glB2T_git64',m.tlIs64)

 ENDIF &&PEMSTATUS(_SCREEN,'gcB2T_git',5)

 llReturn = FILE(m.tc_git)

 RETURN m.llReturn
ENDFUNC &&Get_git_Path

*!*	Ge�ndert durch: SF 4.6.2015
*!*	<pdm>
*!*	<change date="{^2015-06-04,11:20:00}">Ge�ndert durch: SF<br />
*!*	Add output of curent git branch (if one exist)
*!*	</change>
*!*	</pdm>

PROCEDURE GetBranch		&&Internal. Return active git branch

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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 4.6.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

 LOCAL;
  lcRet AS CHARACTER,;
  lnSec AS NUMBER

 lcRet = ''
 IF Is_git() THEN
*schl�gt irgendwie mit bash fehl, daher erstmal wieder cmd
  IF Run_git('rev-parse --abbrev-ref HEAD>git_x.tmp',,.F.,.F.,.T.) THEN

*!*	 LPARAMETERS;
*!*	  tcParameters,;
*!*	  tlShow,;
*!*	  tlIn_Shell,;
*!*	  tlComplex,;
*!*	  tnExitCode

   lnSec = SECONDS()

   IF FILE('git_x.tmp') THEN
    lcRet = CHRTRAN(FILETOSTR('git_x.tmp'),0h0d0a,'')
    DELETE FILE git_x.tmp
   ENDIF &&FILE('git_x.tmp')
  ENDIF &&Run_git('rev-parse --abbrev-ref HEAD>git_x.tmp',,.F.,.F.,.T.)
 ENDIF &&Is_git()

 RETURN m.lcRet
ENDPROC &&GetBranch
*!*	/Ge�ndert durch: SF 4.6.2015

*!*	Changed by: SF 12.6.2015
*!*	<pdm>
*!*	<change date="{^2015-06-12,08:07:00}">Changed by SF<br />
*!*	Move git ShellExecute from <expr>RUN</expr> to API_AppRun
*!*	</change>
*!*	</pdm>

FUNCTION Run_git		&&Internal. Run a git root command
 LPARAMETERS;
  tcParameters,;
  tcLaunchPath,;
  tlShow,;
  tlIn_Shell,;
  tlComplex,;
  tnExitCode

*!*	<pdm>
*!*	<descr>Run git program</descr>
*!*	<params name="tcParameters" type="Character" byref="0" dir="" inb="0" outb="0">
*!*	<short>parameters for git</short>
*!*	<detail></detail>
*!*	</params>
*!*	<params name="tcLaunchPath" type="Character" byref="0" dir="" inb="0" outb="0">
*!*	<short>Launch path</short>
*!*	<detail></detail>
*!*	</params>
*!*	<params name="tlShow" type="Boolean" byref="0" dir="" inb="1" outb="0">
*!*	<short>Show command window>/short>
*!*	<detail></detail>
*!*	</params>
*!*	<params name="tlIn_Shell" type="Boolean" byref="0" dir="" inb="1" outb="0">
*!*	<short>Run command in CMD.>/short>
*!*	<detail>
*!*	<p>Some git commands like to be run in CMD, some dislike. Now we have a switch.</p>
*!*	<p>In general redirection of output (git status>xy.txt) needs CMD.</p>
*!*	</detail>
*!*	</params>
*!*	<params name="tlComplex" type="Boolean" byref="0" dir="" inb="1" outb="0">
*!*	<short>Does not run as a single command,/short>
*!*	<detail>
*!*	<p>Only if <pdmpara num="4" /> is false.</p>
*!*	<p>A rather complex command, like a pipe.</p>
*!*	</detail>
*!*	</params>
*!*	<params name="tnExitCode" type="Variant" byref="1" dir="out" inb="1" outb="0">
*!*	<short>Exitcode of the app.</short>
*!*	<detail>Exitcode as provided by <see pem="Run_ExtApp" /> to use of calling code.</detail>
*!*	</params>
*!*	<remarks>Run API_AppRun to run git.
* Uses <i>cmd</i> to perform piping operations.</remarks>
*!*	<retval type="Boolean">Success</retval>
*!*	<comment>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 25.9.2019 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

*!*	Changed by: SF 25.9.2019
*!*	<pdm>
*!*	<change date="{^2019-09-25,15:13:00}">Changed by: SF<br />
*!*	New Parameter, new way to call bash.
*!*	</change>
*!*	</pdm>
*!*	Changed by: SF 28.05.2020
*!*	<pdm>
*!*	<change date="{^2020-05-28,08:17:00}">Changed by: SF<br />
*!*	New Parameter, return ExitCode of external program.
*!*	</change>
*!*	</pdm>

*!*	SF Changed by: SF 11.2.2021
*!*	<pdm>
*!*	<change date="{^2021-02-11,15:52:00}">Changed by: SF<br />
*!*	New Parameter, Launchpath.<br/>
*!*	Changed strategy to call, check for 64bit git
*!*	</change>
*!*	</pdm>


 LOCAL;
  lc_Git    AS CHARACTER,;
  lcCommand AS CHARACTER,;
  llReturn  AS BOOLEAN,;
  llIs64    AS BOOLEAN,;
  llInBash  AS BOOLEAN

*!*	Changed by: SF 17.9.2015
*!*	<pdm>
*!*	<change date="{^2015-09-17,04:43:00}">Changed by: SF<br />
*!*	switch between with CMD and without.
*!*	</change>
*!*	</pdm>

 llInBash = TYPE('_SCREEN.gcB2T_UseBash')="C" AND _SCREEN.gcB2T_UseBash=="1"

 tnExitCode = 0
*rund cmd to perform piping data
 DO CASE
  CASE !Get_git_Path(@lc_Git,@llIs64)
*error, no git, not gitted
  CASE !m.llIs64 AND !m.tlIn_Shell AND m.tlComplex
*not if 64bit git
*should run without shell, but command is to complex, for example a pipe

* might be removed if we figure out how to run 64bit git
* what seems the problem for complex at all
   lcCommand = ;
    '"'+FORCEPATH('bash.exe',FORCEPATH('bin',JUSTPATH(JUSTPATH(lc_Git))))+'" --login -i '+;
    '-c "git '+CHRTRAN(m.tcParameters,'\','/')+'"'

  CASE !m.llIs64 AND !m.tlIn_Shell
*not if 64bit git
*just command
   lcCommand = '"'+m.lc_Git+'" '+m.tcParameters

  CASE m.tlIn_Shell AND m.llInBash
*command with bash
   lcCommand = ;
    '"'+FORCEPATH('git-bash.exe',JUSTPATH(JUSTPATH(m.lc_Git)))+'" '+;
    '-c "git '+CHRTRAN(m.tcParameters,'\','/')+'"'

  CASE m.tlIn_Shell
*command with cmd
   lcCommand = 'cmd /c ""'+m.lc_Git+'" '+m.tcParameters+'"'

  OTHERWISE
*64bit, not handled better, falls back to cmd
   lcCommand = 'cmd /c ""'+m.lc_Git+'" '+CHRTRAN(m.tcParameters,'/','\')+'"'
 ENDCASE

 IF !EMPTY(m.lcCommand) THEN

  DO CASE
   CASE EMPTY(m.tcLaunchPath)
    tcLaunchPath = JUSTPATH(FULLPATH(CURDIR()))
   OTHERWISE
    tcLaunchPath = JUSTPATH(ADDBS(m.tcLaunchPath))
  ENDCASE

  llReturn = Run_ExtApp(m.lcCommand,m.tcLaunchPath,;
   IIF(m.tlShow,'NOR','HID'),@tnExitCode)

 ENDIF &&!EMPTY(m.lcCommand)

*!*	/Changed by: SF 17.9.2015

 RETURN m.llReturn

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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 12.6.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

*!*	SF Changed by 11.2.2021
*!*	<pdm>
*!*	<change date="{^2021-02-11,15:35:00}">SF Changed by<br />
*!*	Error handling for error in API_Run init, Messagebox
*!*	</change>
*!*	</pdm>

 LOCAL;
  lcVCX AS CHARACTER,;
  loAPI AS "API_AppRun" OF "..\..\BIN2TEXT\LIBRARY\BIN_2_TEXT.VCX"

*for testing purposes
 lcVCX = 'e:\se\bin2text\library\Bin_2_Text.vcx'
*runnning
 loAPI = NEWOBJECT('API_AppRun',m.lcVCX,'',m.tcCommandLine,m.tcLaunchDir,m.tcWindowMode)
 tnExitCode = -1

 IF VARTYPE(m.loAPI)='O' AND !ISNULL(m.loAPI) THEN
  IF EMPTY(m.loAPI.icErrorMessage) THEN
   IF m.tlNoWait THEN
    IF m.loAPI.LaunchApp() THEN
     tnExitCode = NVL(m.loAPI.CheckProcessExitCode(),-1)
    ENDIF &&m.loAPI.LaunchApp()
   ELSE  &&m.tlNoWait
    IF m.loAPI.LaunchAppAndWait() THEN
*    tnExitCode = NVL(m.loAPI.CheckProcessExitCode(),-1)
     tnExitCode = m.loAPI.CheckProcessExitCode()
     tnExitCode = NVL(m.tnExitCode,-1)
    ENDIF &&m.loAPI.LaunchAppAndWait()
   ENDIF &&m.tlNoWait
  ENDIF &&EMPTY(m.loAPI.icErrorMessage)

  IF !EMPTY(m.loAPI.icErrorMessage) THEN
   MESSAGEBOX(m.loAPI.icErrorMessage,0,'API Run / Bin2Text v'+dcB2T_Verno)
  ENDIF &&!EMPTY(m.loAPI.icErrorMessage)
 ENDIF &&VARTYPE(m.loAPI)='O' AND !ISNULL(m.loAPI)

 loAPI = .NULL.

 RETURN tnExitCode=0

ENDFUNC &&Run_ExtApp
*!*	/Changed by: SF 15.9.2015
*!*	/Changed by SF 12.6.2015

FUNCTION HelpMsg	&&Internal. Display help message for external functions

 #DEFINE dcText_DE_H00;
  [Run:]+0h0d0a+;
  [DO Convert_Pjx IN RunB2T.prg]+" [OF Bin2Text.app]"+0h0d0a+;
  [ IDE Interface f�r FoxBin2Prg]+0h0D0A0D0A+;
  [DO Pjx2Commit IN RunB2T.prg]+" [OF Bin2Text.app]"+0h0d0a+;
  [ Wandle alle Dateien aller PJX im Verzeichnis nach Text]+0h0d0a+;
  [ und starte "git commit -a"]+0h0D0A0D0A+;
  [DO Inter_Active IN RunB2T.prg]+" [OF Bin2Text.app]"+0h0d0a+;
  [ Starte Einstellungsmaske.]+0h0D0A0D0A+;
  [DO InitMenu IN RunB2T.prg]+0h0d0a+;
  [ Starte Men�]+0h0D0A0D0A+;
  [DO Convert_Array IN RunB2T.prg]+" [OF Bin2Text.app]"+0h0d0a+;
  [ IDE Interface f�r FoxBin2Prg, f�r ein Datei Array]+0h0D0A0D0A+;
  [DO Convert_File IN RunB2T.prg]+" [OF Bin2Text.app]"+0h0d0a+;
  [ IDE Interface f�r FoxBin2Prg, f�r eine w�hlbare Datei oder Klasse.]+0h0D0A0D0A+;
  [DO Convert_Directory IN RunB2T.prg]+" [OF Bin2Text.app]"+0h0d0a+;
  [ IDE Interface f�r FoxBin2Prg, f�r ein Verzeichnis.]

 #DEFINE dcText_DE_H01;
  "DO Convert_Pjx IN Bin2Text.app [[/?]|[lToBin[,nProjects[,nMode]]"+0h0d0a+;
  [ IDE Interface f�r FoxBin2Prg]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?        Zeigt diesen Hilfstext]+0h0d0a+;
  [  lToBin    Wenn wahr werden die Bi�rdateien erzeugt,]+0h0d0a+;
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
  [Alle Projekte werden tempor�r geschlossen.]+0h0d0a+;
  [F�hrt ein CLEAR ALL aus]

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
  [ Starte Men�]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?        Zeigt diesen Hilfstext]+0h0d0a+;
  [  tcPath    Pfad zur Einstellungsdatei.]+0h0d0a+;
  [  tlNoMenu  Starte das Men� nicht.]

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
  [ IDE interface f�r FoxBin2Prg, to be used with menu]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?        Zeigt diesen Hilfstext]+0h0d0a+;
  [  aFiles    Array mit Dateien]+0h0d0a+;
  [            Eine Spalte Datienamen mit pfad der Bin�rdatei]+0h0d0a+;
  [            Optionale zweite Spalte, wenn die erste in Projekt enth�lt den Projecthook]+0h0d0a+;
  [  lToBin    Wenn wahr werden die Bi�rdateien erzeugt,]+0h0d0a+;
  [            sonst werden Textdateien erzeugt.(Default)]+0h0d0a+;
  [  cMode     Modus f�r Projekt - Dateien.]+0h0d0a+;
  [            Optional in FoxBin2PRG Stil]+0h0d0a+;
  [            Wenn dieser Parameter nicht angegben ist werden pjx wie einfache Dateien behandelt]+0h0d0a+;
  [Classlibraries und Projecthooks werden nicht freigegeben.]

 #DEFINE dcText_DE_H10;
  "DO Convert_Array IN Bin2Text.app [/?]|lToBin,cMode,@aFiles"+0h0D0A0D0A+;
  [Nur aus der IDE starten.]

 #DEFINE dcText_DE_H11;
  "DO Convert_File IN Bin2Text.app [/?]|[lToBin[,lSingleClass]]"+0h0d0a+;
  [ IDE interface f�r FoxBin2Prg, um eine w�hlbare Datei zu transformieren.]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?            Zeigt diesen Hilfstext]+0h0d0a+;
  [  lToBin        Wenn wahr werden die Bi�rdateien erzeugt,]+0h0d0a+;
  [                sonst werden Textdateien erzeugt.(Default)]+0h0d0a+;
  [                Optional in FoxBin2PRG Stil]+0h0d0a+;
  [  lSingleClass  Bestimme eine Klasse zum Transformieren.]+0h0d0a+;
  [F�hrt ein CLEAR ALL aus.]


 #DEFINE dcText_DE_H12;
  "DO Convert_Directory IN Bin2Text.app [/?]|[lToBin[,tlWithSub]]"+0h0d0a+;
  [ IDE interface f�r FoxBin2Prg, um ein Verzeichnis zu transformieren.]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?            Zeigt diesen Hilfstext]+0h0d0a+;
  [  lToBin        Wenn wahr werden die Bi�rdateien erzeugt,]+0h0d0a+;
  [                sonst werden Textdateien erzeugt.(Default)]+0h0d0a+;
  [                Optional in FoxBin2PRG Stil]+0h0d0a+;
  [  tlWithSub     Inklusive Unterverzeichnisse.]+0h0d0a+;
  [F�hrt ein CLEAR ALL aus.]


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
  [ IDE interface for FoxBin2Prg, to be used with an array of files.]+0h0D0A0D0A+;
  [DO Convert_File IN RunB2T.prg]+" [OF Bin2Text.app]"+0h0d0a+;
  [ IDE interface for FoxBin2Prg, pick a file or class to convert.]+0h0D0A0D0A+;
  [DO Convert_Directory IN RunB2T.prg]+" [OF Bin2Text.app]"+0h0d0a+;
  [ IDE interface for FoxBin2Prg, pick a directory to convert.]

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


 #DEFINE dcText_EN_H11;
  "DO Convert_File IN Bin2Text.app [/?]|[lToBin[,lSingleClass]]"+0h0d0a+;
  [ IDE interface for FoxBin2Prg, pick a file or class to transform.]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?            This help message]+0h0d0a+;
  [  lToBin        If true, create binaries,]+0h0d0a+;
  [                if false create text files.(Default)]+0h0d0a+;
  [                Optional in FoxBin2PRG style]+0h0d0a+;
  [  lSingleClass  Select a class to transform.]+0h0d0a+;
  [This will use CLEAR ALL!]

 #DEFINE dcText_EN_H12;
  "DO Convert_Directory IN Bin2Text.app [/?]|[lToBin[,tlWithSub]]"+0h0d0a+;
  [ IDE interface for FoxBin2Prg, pick a directory transform.]+0h0d0a+;
  [ Parameter:]+0h0d0a+;
  [  /?            This help message]+0h0d0a+;
  [  lToBin        If true, create binaries,]+0h0d0a+;
  [                if false create text files.(Default)]+0h0d0a+;
  [                Optional in FoxBin2PRG style]+0h0d0a+;
  [  tlWithSub     Include subdirectoris.]+0h0d0a+;
  [This will use CLEAR ALL!]

 LPARAMETERS;
  tnHelp

*!*	<pdm>
*!*	<descr>Displays a help message.</descr>
*!*	<params name="tnHelp" type="Numeric" byref="0" dir="" inb="0" outb="0">
*!*	<short>Help number.</short>
*!*	<detail></detail>
*!*	</params>
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 14.4.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

 _SCREEN.SHOW()
 _SCREEN.VISIBLE = .T.

 LOCAL;
  lcOut  AS CHARACTER,;
  lnMemo AS NUMBER

 DO CASE
  CASE m.tnHelp=01
   lcOut = dcText_EN_H01
  CASE m.tnHelp=02
   lcOut = dcText_EN_H02
  CASE m.tnHelp=03
   lcOut = dcText_EN_H03
  CASE m.tnHelp=04
   lcOut = dcText_EN_H04
  CASE m.tnHelp=05
   lcOut = dcText_EN_H05
  CASE m.tnHelp=06
   lcOut = dcText_EN_H06
  CASE m.tnHelp=07
   lcOut = dcText_EN_H07
  CASE m.tnHelp=08
   lcOut = dcText_EN_H08
  CASE m.tnHelp=09
   lcOut = dcText_EN_H09
  CASE m.tnHelp=10
   lcOut = dcText_EN_H10
  CASE m.tnHelp=11
   lcOut = dcText_EN_H11
  CASE m.tnHelp=12
   lcOut = dcText_EN_H12
  OTHERWISE
   lcOut = dcText_EN_H00
 ENDCASE

 lnMemo = SET("Memowidth")
 SET MEMOWIDTH TO 80
 ?'Bin2Text v'+dcB2T_Verno FONT "Courier",12
 ?m.lcOut FONT "Courier"
 SET MEMOWIDTH TO (m.lnMemo)
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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 19.4.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

 LOCAL ARRAY;
  laError(1,7)

 AERROR(laError)
 MESSAGEBOX('Ooops, works not as expected.'+0h0d0a0d0a+;
 'Error:'+PADL(laError(1,1),5)+', '+laError(1,2)+0h0d0a+;
  'Code block: '+m.tcProgram+0h0d0a+;
  'Code line: '+PADL(m.tnLineNo,7),;
  64,'Bin2Text v'+dcB2T_Verno)
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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 19.4.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

 DO CASE
  CASE m.tlOn
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

PROCEDURE Compare_VerNo	  &&Internal. Compare version number
 LPARAMETERS ;
  tcVerNo1,;
  tcVerNo2
  
*!*	<pdm>
*!*	<descr>Compare Version numbers</descr>
*!*	<params name="tcVerNo1" type="Character" byref="0" dir="" inb="0" outb="0">
*!*	<short>Version number 1 in form nnnnn[.nnnnn[.nnnnn ... ]]]</short>
*!*	<detail>1 to 4 groups. Max 4 digits per group. Trailing groups will be ignored.</detail>
*!*	</params>
*!*	<params name="tcVerNo2" type="Character" byref="0" dir="" inb="0" outb="0">
*!*	<short>Version number 2 in form nnnn[.nnnn[.nnnn ... ]]]</short>
*!*	<detail>1 to 4 groups. Max 4 digits per group. Trailing groups will be ignored.</detail>
*!*	</params>
*!*	<comment>
*!*	<retval type="Number">
*!*	<dl>
*!*	 <dt>0</dt>
*!*	 <dd><expr>m.tcVerNo1=m.tcVerNo2</expr></dd>
*!*	 </dl><dt>1</dt>
*!*	 <dd><expr>m.tcVerNo1>m.tcVerNo2</expr></dd>
*!*	 </dl><dt>2</dt>
*!*	 <dd><expr>m.tcVerNo1<m.tcVerNo2</expr></dd>
*!*	</dl>
*!*	</retval>
*!*	<remarks></remarks>
*!*	<example></example>
*!*	<seealso>
*!*	 <see loca="" class="" pem=""></see>
*!*	</seealso>
*!*	<appliesto toref="0" toalso="0" />
*!*	</comment>
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 3.3.2021 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm> 

 LOCAL;
  lnPos	  AS NUMBER,;
  lnVerNo1 AS NUMBER,;
  lnVerNo2 AS NUMBER

 lnVerNo1 = 0
 lnVerNo2 = 0

 FOR lnPos = 0 TO MIN(OCCURS('.',m.tcVerNo1),OCCURS('.',m.tcVerNo2),4)
  lnVerNo1 = m.lnVerNo1*10^4+VAL(GETWORDNUM(m.tcVerNo1,m.lnPos+1,'.'))
  lnVerNo2 = m.lnVerNo2*10^4+VAL(GETWORDNUM(m.tcVerNo2,m.lnPos+1,'.'))
 ENDFOR &&lnPos

 DO CASE
  CASE m.lnVerNo1=m.lnVerNo2
   RETURN 0
  CASE m.lnVerNo1>m.lnVerNo2
   RETURN 1
  OTHERWISE
   RETURN 2
 ENDCASE
ENDPROC &&Compare_VerNo

PROCEDURE ScanDir		&&Internal. Recursivly scan directories
 LPARAMETERS;
  tnAction,;
  tcDir,;
  tlToBin,;
  toConverter

*!*	<pdm>
*!*	<descr>Scan a directory recursive.</descr>
*!*	<params name="tnAction" type="Number" byref="0" dir="" inb="0" outb="0">
*!*	<short>Action for Directory</short>
*!*	<detail>
*1 scan for pjx
*</detail>
*!*	</params>
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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 14.2.2021 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
*!*	</pdm>

 LOCAL;
  lnLoop1,;
  lcOldDir

 LOCAL ARRAY;
  laDir(1)

 lcOldDir = FULLPATH(CURDIR())
 CD (m.tcDir)
 FOR lnLoop1 = 1 TO ADIR(laDir,'','D')
  IF INLIST(laDir(m.lnLoop1,1),'.','..') THEN
   LOOP
  ENDIF &&INLIST(laDir(m.lnLoop1,1),'.','..')
  ScanDir(ADDBS(ADDBS(m.tcDir)+laDir(m.lnLoop1,1)),m.tlToBin,m.toConverter)
 ENDFOR &&lnLoop1
 DO CASE
  CASE m.tnAction=1
   Dir_Action_PJX(m.tcDir,m.tlToBin,m.toConverter)

  OTHERWISE
   ?"error"
 ENDCASE
 CD (m.lcOldDir)
ENDPROC &&ScanDir

PROCEDURE Dir_Action_PJX		&&Internal. Parse a directory for projects (binary or text)
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
*!*	<short>FoxBin2Text object to figure out settings of a given directory.</short>
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
*!*	<copyright>
*!*	<img src="../../repository/vfpxbanner_small.png" alt="VFPX logo"/><br/>
*!*	<p>This project is part of <a href="https://vfpx.github.io/"  title="Skip to VFPX" target="_blank">VFPX</a>.</p>
*!*	<p><i>&copy; 15.6.2015 Lutz Scheffler Software Ingenieurb�ro</i></p>
*!*	</copyright>
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

 IF m.tlToBin THEN
*get local text extension for project
  loInfo      = m.toConverter.Get_DirSettings(m.tcDir)
  lcSourceExt = m.loInfo.c_PJ2

 ELSE  &&m.tlToBin
  lcSourceExt = "PJX"
 ENDIF &&m.tlToBin

 loInfo      = .NULL.

 lnProjs = ADIR(laFiles,'*.'+m.lcSourceExt,'HS')

 IF m.lnProjs>0 THEN
  lnFiles = IIF(EMPTY(_SCREEN.gaFiles),0,ALEN(_SCREEN.gaFiles,1))

  DIMENSION;
   _SCREEN.gaFiles(m.lnFiles+m.lnProjs,2)

  FOR lnProj = 1 TO m.lnProjs
   _SCREEN.gaFiles(m.lnFiles+m.lnProj,1) = FORCEPATH(FORCEEXT(laFiles(m.lnProj,1),"PJX"),m.tcDir)
  ENDFOR &&lnProjs
 ENDIF &&m.lnProjs>0

ENDPROC &&Dir_Action_PJX
