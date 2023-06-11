# Bin 2 Text Extension
## Documentation

A brief description is given in [Bin 2 Text Extension](../README.md).

---
### Requirements
Requires: [FoxBin2Prg](https://github.com/fdbozzo/foxbin2prg), also found on VFPX.
Optional: The use of [git](https://git-scm.com/) is optional.

---
### Change log
See [Bin 2 Text Change Log](./changelog.md) for a short change list.

---
### To use the program:
#### Thor 
* Install via Thor *Check for Updates*
* Install FoxBin2Prg via Thor
* Run like:
```
lcFile   = Execscript (_Screen.cThorDispatcher, "Tool Folder=")+'Components\Bin2Text\Bin2Text.app'
lcFolder = {Your local "root "folder to process from}
DO InitMenu IN (m.lcFile) WITH (m.lcFolder)
```
#### Native
* Pull FoxBin2Prg
* Pull project
* Recreate the binaries using FoxBin2Prg
* Complie the app
* Run `DO InitMenu IN LOCFILE('Bin2Text.app')` from VFP IDE or
* If FoxBin2Prg is no installed by Thor, you will be asked for the location of _FoxBin2Prg.prg_

---
###  Documentation
Help and documentation is in the **local folder** _PDM/index.htm_.

Basic information is on section _How to get it to work_.

----
Last changed: *<!--CVERSIONDATE-->2023-05-20<!--/CVERSIONDATE-->*   
![powered by VFPX](./docs/images/vfpxpoweredby_alternative.gif "powered by VFPX")
