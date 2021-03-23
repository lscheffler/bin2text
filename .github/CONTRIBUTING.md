# How to contribute to FoxBin2Prg
## Bug report?
- Please check  [issues](https://github.com/lscheffler/bin2text/issues) if the bug is reported
- If you're unable to find an open issue addressing the problem, open a new one. Be sure to include a title and clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.
### Did you write a patch that fixes a bug?
- Open a new GitHub merge request with the patch.
- Ensure the PR description clearly describes the problem and solution.
  - Include the relevant version number if applicable.

## Coding conventions

Start reading our code and you'll get the hang of it. We optimize for readability:

- Beautification is done like:
  - Keywords: Upper case 
  - Symbols: First occurence
  - Indentation: Space, 1
  - Indent anything then Comments
- Please do not run BeautifyX with mDots insertion against the code. 
- We NEVER put spaces after list items and method parameters (`[1,2,3]`, not `[1, 2, 3]`), around operators (`x=1`, not `x = 1`).
- This is open source software. Consider the people who will read your code, and make it look nice for them. It's sort of like driving a car: Perhaps you love doing donuts when you're alone, but with passengers the goal is to make the ride as smooth as possible.
- Please kindly add comments where and what you change.
  Prefered in pdm change style, this will be processed into documentation. Please look up the examples in the code.

## New version
Please note, there are some tasks to set up a new version.
Stuff is a bit scattered, so this is where to look up.
1. Please create a fork at github
0. In _stuff.h_ there are two #DEFINES with version numbers:   
`#DEFINE dcB2T_Verno       "1.0.0"`    
`#DEFINE dcFB2P_Verno_Min  "1.19.57"`
4. If available run PDM <a href="http://gorila.netlab.cz/pdm.html" title="PDM"  target="_blank">Project Documenting Machine</a> by Martina Jindrová using the AB-plugins.
   The pdm setting is stored in the _Doku/_ folder.
4. Add a description to _Changes.html_
4. For changed functionality, add descriptive text to _Preface.html_ file.
4. Highlight the change on _README.md_ in projects root
0. Compile to app
1. Change Thor (see below)

## Thor conventions
This project is part of [VFPX](https://vfpx.github.io/) and published via [Thor](https://github.com/VFPX/Thor).   
There are some considerations to make to add a new version to Thor.   
Please check [Supporting Thor Updater](https://vfpx.github.io/thorupdate/)
In special:
- Update _Project.txt_, in special the version number
- Run the script included, or 
   - add files to _Bin2Text.zip_, namly Bin2Text.app
   - Update the version number in _Bin2Text.txt_

Thanks