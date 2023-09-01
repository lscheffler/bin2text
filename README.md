# ![Home](./docs/images/home.png "Home") Bin 2 Text Extension
IDE integration of FoxBin2Prg in VFP   
**Version 1.3.0, 2023-09-01**   
Integration of FoxBin2Prg and git for fast snapshot like commits, and UI to work with single elements.

---
### Synopsis
![VFPX Banner](./docs/images/vfpxbanner.gif "VFPX Banner")   
This is project is part of [VFPX](https://vfpx.github.io/) 

Project manager: [Lutz Scheffler](https://github.com/lscheffler)   
Project location: [Bin2Text](https://github.com/lscheffler/bin2text)   

The main goals of this project are:
- The main goal is to do fast *git* commits.
- Visual FoxPro IDE integration that works with whole projects (sbapshot), not per file.

The problems this project tries to solve:
- Better IDE integration of FoxBin2Prg for VFP
- Faster processing of PJX and groups of corresponding PJXs
- *git commit* integration
- Processing of group of files that can not be addressed with FoxBin2PRG interface
- Processing tables bound to databases by just calling the database

---
### Requirements
- Requires: Microsoft Visual Foxpro; Version 9.0 SP2.
- Runs with VFPA, compiling the APP with VP9 SP2 is recomended.
- Requires: [FoxBin2Prg](https://github.com/lscheffler/foxbin2prg). This version of Bin2Text requires version [1.20.04](https://github.com/lscheffler/foxbin2prg/releases/tag/v1.20.04).
- Optional: The use of *[git for windows](https://git-scm.com/download/win)* is optional.

---
### Installation
1. Download or clone [this repository](https://github.com/lscheffler/bin2text).
2. Downlod or clone FoxBin2Prg
9. **This repository does not ship binary sources.**
3. Run 
```
CD (path_to_Bin2Text)
DO (path_to_)FOXBIN2PRG.PRG WITH JUSTPATH(FULLPATH("bin2text.pj22,"")),"*",,,,,,,,,FULLPATH("Create_Project.cfg","")
```
4. Compile to app
2. Run Bin2Text.app on every start of VFP to hook up the menu like: `DO InitMenu IN LOCFILE('Bin2Text.app')`.

---
### Documentation
Full help and documentation is in *docs/index.htm* in the download file.

For quick run see [Bin 2 Text Documentation](https://github.com/lscheffler/bin2text/blob/master/docs/documentation.md).

### Changes
See [changes](https://github.com/lscheffler/bin2text/blob/master/docs/changelog.md)

## Helping with this project
See [How to contribute to Bin2Text](https://github.com/lscheffler/bin2text/blob/master/.github/CONTRIBUTING.md) for details on how to help with this project.

---
## Note
Bin 2 Text Extension is tested with *[git for windows](https://git-scm.com/download/win)* version 2.39.2.windows.1 (2023-02-06) 32 and 64bit.

----
Last changed: *2023-09-01*   
![powered by VFPX](./docs/images/vfpxpoweredby_alternative.gif "powered by VFPX")
