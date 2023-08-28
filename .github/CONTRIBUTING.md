# How to contribute to Bin2Text
## Bug report?
- Please check  [issues](https://github.com/lscheffler/bin2text/issues) if the bug is reported
- If you're unable to find an open issue addressing the problem, open a new one. Be sure to include a title and clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behaviour that is not occurring.
### Did you write a patch that fixes a bug?
- Open a new GitHub merge request with the patch.
- Ensure the PR description clearly describes the problem and solution.
  - Include the relevant version number if applicable.

## Prerequisites
- you should know how to use git in one or the other way
- it is recommended to have Thor installed, install following tools via Check for Updates:
  - FoxBin2Prg must be installed
  - it is recommended to have Bin2Text (this project) installed

## Coding conventions

Start reading our code and you'll get the hang of it. We optimize for readability:

- Beautification is done like:
  - Keywords: Upper case 
  - Symbols: First occurrence
  - Indentation: Space, 1
  - Indent anything then Comments
- Please do not run BeautifyX with mDots insertion against the code. 
- We NEVER put spaces after list items and method parameters (`[1,2,3]`, not `[1, 2, 3]`), around operators (`x=1`, not `x = 1`).
- This is open source software. Consider the people who will read your code, and make it look nice for them. It's sort of like driving a car: Perhaps you love doing donuts when you're alone, but with passengers the goal is to make the ride as smooth as possible.
- Please kindly add comments where and what you change.
  Preferred in pdm change style, this will be processed into documentation. Please look up the examples in the code.

## New version
Please note, there are some tasks to set up a new version.
Stuff is a bit scattered, so this is where to look up.
1. Please create a fork at github
2. If already forked, remember to first `git pull` the most recent code.
3. In _stuff.h_ there is a #DEFINE about minimum FoxBin2Prg required for this project:   
`#DEFINE dcFB2P_Verno_Min  "1.20.00"`
4. Add a description of changes to _Doku/Source/Changes.html_ (this is for PDM docu)
5. For changed functionality, add descriptive text to _Doku/Source/Preface.html_ file. (this is for PDM docu)
6. Check of the git version mentioned in _Doku/Source/Preface.html_ and _README.md_ might be updated.
7. Highlight the change on _README.md_ in projects root
8. Add a description of changes to _.github/ChangeLog.md_ (this is for github docu)
9. Change date in the footer of documentation files touched.
10. If available run PDM <a href="http://gorila.netlab.cz/pdm.html" title="PDM"  target="_blank">Project Documenting Machine</a> by Martina Jindrová using the AB-plugins.
  The pdm setting is stored in the _Doku/_ folder.
11. commit changes to git
12. push

----
Last changed: 2023-08-28

![powered by VFPX](../docs/Images/vfpxpoweredby_alternative.gif "powered by VFPX")
