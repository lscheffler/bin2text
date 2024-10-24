# Change log of Bin 2 Text Extension

IDE integration of FoxBin2Prg in VFP   

This page gives a brief overview of changes to the [Bin 2 Text Extension](https://github.com/lscheffler/bin2text).

A complete list of changes is available on the offline documentation via **local folder** _docu/index.htm_.

This version of Bin2Text requires version [1.21.01](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.21.01) of FoxBin2Prg.

## Release History

---
### 2024-10-22, Version 1.3.4
Stable release.
* Better integration with Thor, use FoxBin2Prg if installed by Thor as default.

---
### 2024-10-21, Version 1.3.3
Stable release.
* Missing xxx while processing. Randomly missing variable error. Issue #9

---
### 2024-10-21, Version 1.3.2
Stable release.
* Problem running Bin2Text.exe when the path to it conataines a space. Issue #8

---
### 2024-10-18, Version 1.3.1
Stable release.
* The property to store the location of FoxBin2Prg was not created and failed. Issue #7 (auerswald)

---
### 2023-12-05, Version 1.3.0
Stable release.
* Fit to latest version of FoxBin2Prg.
* New option to use a fixed config file for FoxBin2Prg.
* New option to allow logging for FoxBin2Prg.
* Optimized temp storage of open PJX.
* Fixed issue with "Path recursive" on 2Bin, if no pj2 was found.
* Allowed (re)generation of single file PJX.
         
---
### 2023-08-22, Version 1.2.3
Stable release.
* Fixed an issue where tables of a database where not recreated

---
### 2023-06-11, Version 1.2.2
Stable release.
* Search for FoxBin2Prg with Thor failed, issue #5

---
### 2023-05-21, Version 1.2.1
Stable release.
* FoxBin2Prg will now be loaded from Thor, if installed
* Thor deployment of project now with VFPX Deployment (internal)

---
### 2023-02-27, Version 1.2.0
Stable release.
* Bug fixes Text files of SCX deleted; Fixed an issue where text files of an SCX gets deleted. issue#3

---
### 2021-12-07, Version 1.1.5
Stable release.
* Bug fixes Path change fixed; Fixed condition where additonal app closed by CLEAR ALL resets current path. Problems with additional (relative) files.
* String to long; Fixed problem on file hashing for large files.

---
### 2021-06-02, Version 1.1.4
Stable release.
* Bug fixes Commit, auto message; Only parts of the message where put into the commit

---
### 2021-05-20, Version 1.1.3
Stable release.
* Enhancement EXE; Switched from APP to EXE file on execution.
* Enhancement calling of git; Improved call of git via bash.
* Enhancement Text2Bin for classes via menu; Additional options to create binary.
  * Pick text file and add to common VCX.
  * Pick text file and create a single VCX like class.
  * Pick class from classlin and regenerate from tex file.

---
### 2021-04-12, Version 1.1.2
Stable release.
* Bug fixes Text to Bin, Files; Wrong parameter
* Enhancement File based operations; Better definition of file types.

---
### 2021-03-29, Version 1.1.1
Stable release.
* Additional files Internal set counter wrong
* Processing of projects. Error on files missing and user canceled MODI PROJECT.
* Processing of tags on non free tables. Processing of tags let databases open what would raise handling the DBC.
* Iterating subdirs. Call on itertation used wrong parameter.
* Better integration into [Thor](https://github.com/VFPX/Thor).

---
### 2021-03-23, Version 1.0.0
Stable release.
* Changes to tags will force processing whole DBF / DBC.
* Option to process the table files of a database.
* For multi project operations (this means any all-project based operation not for active project), a list of files will be included.
* Reworked settings form
* Option to run all files of directories.
* better distinction between 32bit and 64bit for calling git 
* recognition of installation of _git for windows_ per user. (not in Program Files)
* Selectable GUI, The open GUI menu item could run any program.
* Improved shell, The shell used for _git-commit_ and to display shell could be selected between _bash_ and _cmd_
* Better call for _git-commit_. Opens _git-commit_ editor window in correct shell.
* FoxBin2Prg config, Use the FoxBin2Prg setting of input files folder for processing.
* Branch on caption, GetBranch will write active branch to caption.
* Text output, Improved messages.
* Active branch, The branch active is printed on screen after many operations.
* Moved docu to better fit github standards.
* Better integration into [Thor](https://github.com/VFPX/Thor).
* Reworked to reflect changes to [FoxBin2Prg](https://github.com/fdbozzo/foxbin2prg).
* Link to VFPX to display latest version of _git_ tested.
* Links to github updated.

---
### 2017-04-20, Version 0.13.2
* Opens git-bash without additional windows.

---
### 2017-04-19, Version 0.13.1
* Problems locating binaries for git for windows version 2.6.3.windows.1 (2015-11-05). Registry key was changed.

---
### 2017-04-19, Version 0.13.0
* Problems with calls of git. This was blocking the commit menu item.

---
### 2017-04-19, Version 0.12.1
* Obsolete debug statement removed

---
### 2017-04-19, Version 0.12.0
* New menu items to run gitbash and history.
* Removed problems  _git_ path.
* fixed problems deleting obsolete files.

---
### 2017-04-19, Version 0.11.0
* New menu items to run directory recursive.
* Removed problems with asynchronous processing of _git_
* minor bug fixes

---
### 2017-04-19, Version 0.10.0
* Distinct menu items to _git commit_ for active and all projects.
* Obsolete text files can be erased if binary file / class (for vcx files) / object (for scx files) is removed.
* Improved detection of table changes

---
### 2017-10-19, Version 0.9.0
* Initial push to github

----
Last changed: *<!--CVERSIONDATE-->2024-10-22<!--/CVERSIONDATE-->*   
![powered by VFPX](./images/vfpxpoweredby_alternative.gif "powered by VFPX")
