lparameters toUpdateObject
local lcAppName, ;
	lcAppID, ;
	lcRepositoryURL, ;
	lcDownloadsURL, ;
	lcVersionFileURL, ;
	lcZIPFileURL, ;
	lcRegisterWithThor

* Set the project settings; edit these for your specific project.

lcAppName       = 'Bin2Text'
	&& the name of the project
lcAppID         = 'Bin2Text'
	&& similar to lcAppName but must be URL-friendly (no spaces or other
	&& illegal URL characters)
lcRepositoryURL = 'https://github.com/lscheffler/bin2text'
	&& the URL for the project's repository

* If the version file and zip file are in the ThorUpdater folder of the
* master branch of a GitHub repository, these don't need to be edited.
* Otherwise, set lcVersionFileURL and lcZIPFileURL to the correct URLs.

lcDownloadsURL   = strtran(lcRepositoryURL, 'github.com', ;
	'raw.githubusercontent.com') + '/master/ThorUpdater/'
lcVersionFileURL = lcDownloadsURL + lcAppID + 'Version.txt'
	&& the URL for the file containing code to get the available version number
lcZIPFileURL     = lcDownloadsURL + lcAppID + '.zip'
	&& the URL for the zip file containing the project

* This is code to execute after the project has been installed by Thor for the
* first time. Edit this if you want do something different (such as running
* the installed code) or display a different message. You can use code like
* this if you want to execute the installed code; Thor replaces
* ##InstallFolder## with the installation path for the project:
*
* 'do "##InstallFolder##MyProject.prg"'

text to lcRegisterWithThor noshow textmerge
	messagebox('From the Thor menu, choose "More -> Open Folder -> Components" to see the folder where <<lcAppName>> was installed', 0, '<<lcAppName>> Installed', 5000)
endtext

* Set the properties of the passed updater object. You likely won't need to edit this code.

with toUpdateObject
	.ApplicationName      = lcAppName
	.Component            = 'Yes'
	.VersionLocalFilename = lcAppID + 'VersionFile.txt'
	.RegisterWithThor     = lcRegisterWithThor
	.VersionFileURL       = lcVersionFileURL
	.SourceFileUrl        = lcZIPFileURL
	.Link                 = lcRepositoryURL
	.LinkPrompt           = lcAppName + ' Home Page'
	.Notes                = GetNotes()
endwith
return toUpdateObject

* Get the notes for the project. Edit this code as necessary.

procedure GetNotes
local lcNotes
text to lcNotes noshow
Bin2Text

Project Manager: Lutz Scheffler

Bin2Text is an extension to FoxBin2Prg to access via menu, only process binaries changed, and create fast git commits.
Capability to process tables of databases with the database.

A complete list of changes is available on the offline documentation via local folder docu/index.htm.

+++++++++++++++++++++++ Change log +++++++++++++++++++++++

---
### Version 1.1.4

Stable release.
* Fixed problem with automated message while commiting PJX's

### Version 1.1.3

Stable release.
* Enhanced calling of git
* Enhanced menu structure, new targets for Class_2Bin

### Version 1.1.2

Stable release.
* Bugfixes
* Getfile dialog improved

### Version 1.1.1

Stable release.
* Additional files Internal set counter wrong
* Processing of projects. Error on files missing and user canceled MODI PROJECT.
* Processing of tags on non free tables. Processing of tags let databases open what would raise handling the DBC.
* Iterating subdirs. Call on itertation used wrong parameter.
* Better integration into https://github.com/VFPX/Thor.
 
---
### Version 1.0.0
Stable release.
* Changes to tags will force processing whole DBF / DBC.
* Option to process the table files of a database.
* For multi project operations (this means any all-project based operation not for active project), a list of files will be included.
* Reworked settings form
* Option to run all files of directories.
* better distinction between 32bit and 64bit for calling git 
* recognition of installation of git for windows per user. (not in Program Files)
* Selectable GUI, The open GUI menu item could run any program.
* Improved shell, The shell used for git-commit and to display shell could be selected between bash and cmd
* Better call for git-commit. Opens git-commit editor window in correct shell.
* FoxBin2Prg config, Use the FoxBin2Prg setting of input files folder for processing.
* Branch on caption, GetBranch will write active branch to caption.
* Text output, Improved messages.
* Active branch, The branch active is printed on screen after many operations.
* Moved docu to better fit github standards.
* Better integration into https://github.com/VFPX/Thor.
* Reworked to reflect changes to https://github.com/fdbozzo/foxbin2prg.
* Link to VFPX to display latest version of git tested.
* Links to github updated.

---
### Version 0.13.2
* Opens git-bash without additional windows.

---
### Version 0.13.1
* Problems locating binaries for git for windows version 2.6.3.windows.1 (2015-11-05). Registry key was changed.

---
### Version 0.13.0
* Problems with calls of git. This was blocking the commit menu item.

---
### Version 0.12.1
* Obsolete debug statement removed

---
### Version 0.12.0
* New menu items to run gitbash and history.
* Removed problems  git path.
* fixed problems deleting obsolete files.

---
### Version 0.11.0
* New menu items to run directory recursive.
* Removed problems with asynchronous processing of git
* minor bug fixes

---
### Version 0.10.0
* Distinct menu items to git commit for active and all projects.
* Obsolete text files can be erased if binary file / class (for vcx files) / object (for scx files) is removed.
* Improved detection of table changes

---
### Version 0.9.0
* Base version
endtext

return lcNotes
