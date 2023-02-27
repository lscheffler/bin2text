# ![](content/home.png "Home") Bin 2 Text Extension
## Provides better IDE integration of FoxBin2Prg in VFP

---
### Synopsis
This is project is part of [VFPX](https://vfpx.github.io/) 

![VFPX](content/vfpxlogo.gif "VFPX")

Project manager: [Lutz Scheffler](https://github.com/lscheffler)   
Project location: [Bin2Text](https://github.com/lscheffler/bin2text)   

The main goals of this project are:
* The main goal is to do fast _git_ commits.
* Visual FoxPro IDE integration that works with whole projects, not per file.

The problems this project tries to solve:
* Better IDE integration of FoxBin2Prg for VFP
* Faster processing of PJX and groups of corresponding PJXs
* _git commit_ integration
* Processing of group of files that can not be addressed with FoxBin2PRG interface
* Processing tables bound to databases by just calling the database

---
### Requirements
- Requires: Microsoft Visual Foxpro; Version 9.0 SP2.
- Runs with VFPA, compiling the APP with VP9 SP2 is recomended.
- Requires: [FoxBin2Prg](https://github.com/fdbozzo/foxbin2prg), also found on VFPX.
- Optional: The use of [git](https://git-scm.com/) is optional.

---
### Installation
1. Download or clone this repository.   
2. Downlod or clone FoxBin2Prg
9. **This repository does not ship binary sources.**
3. Run `DO FOXBIN2PRG.PRG WITH "bin2text.pj2", "*"`
   - check appropriate for path
4. Compile to EXE

---
### Documentation
Full help and documentation is in _docs/index.htm_ in the download file.

For quick run see [Bin 2 Text Documentation](content/documentation.md).

---
## Note
Bin 2 Text Extension is tested with _git for windows_ version 2.39.2.windows.1 (2023-02-06) 32 and 64bit.

----
Last changed: _2023/02/27_ ![Picture](./content/vfpxpoweredby_alternative.gif)