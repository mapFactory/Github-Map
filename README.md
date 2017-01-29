
##How to install.
<pre>
install ruby ... #ruby instructions to be added.
bundle install rake<br>
<br>verify the install <b>command:</b> rake --version; ruby -v;
</pre>
##How to use.
###(1)To check the functionality of the program without any user action.
(1_0) clone down the Github-Repo-Submodulizer
<br>(1_1)<b>commands:</b>
<br>&emsp;&emsp;&emsp;rake test_submodulize_folder  &emsp;&emsp;&emsp;#build</b>
<br>&emsp;&emsp;&emsp;rake test_desubmodulize_folder          &emsp;&emsp;#revert back</b>

<br>Navigate to ... www.github.com/miketestgit02

###(2)Influence your own repository... 
(2_0) Navigate inside of Github-Repo-Submodulizer to the subfolder named "my_repositories" 
<br>(2_1) the folders inside "my_repositories" can be input as a folder name. to see how the functionality works.
<br>(2_2) to operate this program on your repository/project: move that project into "my_repositories" 
<br>(2_3) make note of the repository name because you will be prompted for it in the program.
<br>(2_4)<b>commands:</b>
<br>&emsp;&emsp;&emsp;rake submodulize_folder &emsp;&emsp;&emsp;&emsp;&emsp;#build
<br>&emsp;&emsp;&emsp;rake de_submodulize_folder &emsp;&emsp;&emsp;&emsp;#revert back

###layout
<pre>
          initializeSubmoduleLogic()
              createRepo()...
              touchWithReadme()
                navToSubFolder()
                  initialize()#not a folder produces the exit procedure... 
                  ...removeFiles();commit_andPush();
*******************************************************************************************
submodulizeFolder()
  eachSubDir()
     initializeSubmodule()
      eachSubDir()
        initializeSubmodule()
</pre>

###Map
<pre>
l = "leaf"
Computations1: bottom directories have standard spacing. Directories above have summation spacing.
Computations2: start taken as param... end computed then min.

layer1 |                                                  dir1(comp 2subSum)
layer2 |                           dir1(comp 1 subSum)            |               dir2(comp 1 subSum)
layer3 |                           dir1(comp 2subSum)             |               dir2(l)
layer4 |      dir1(comp3 subDir)            |  dir2(comp1 subDir)
layer5 |  dir1(l)      dir2(l)      dir3(l) |  dir1
</pre>
####AlternateMap (this is possibly most efficient) ... the structure comes from 
credit for design goes to http://mama.indstate.edu/users/ice/tree/
<pre>
│   │       ├── re.pyc
│   │       ├── site-packages
│   │       │   ├── easy_install.py
│   │       │   ├── easy_install.pyc
│   │       │   ├── external
│   │       │   │   ├── __init__.py
│   │       │   │   ├── __init__.pyc
│   │       │   │   ├── d3
│   │       │   │   │   ├── d3.js
│   │       │   │   │   ├── d3.min.js
│   │       │   │   │   └── package.js
│   │       │   │   ├── eigen_archive
│   │       │   │   │   ├── Eigen
│   │       │   │   │   │   ├── CMakeLists.txt
│   │       │   │   │   │   ├── Cholesky
│   │       │   │   │   │   └── src
│   │       │   │   │   │       ├── Cholesky
│   │       │   │   │   │       │   ├── LDLT.h
│   │       │   │   │   │       │   ├── LLT.h
│   │       │   │   │   │       │   └── LLT_LAPACKE.h
│   │       │   │   │   │       ├── CholmodSupport
│   │       │   │   │   │       │   └── CholmodSupport.h
│   │       │   │   │   │       ├── Core
│   │       │   │   │   │       │   ├── Array.h
│   │       │   │   │   │       │   ├── ArrayBase.h
</pre>

<b>Copyright (c) 2017, Ryan Murphy and Michael Dimmitt</b>
