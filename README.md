###Issues to Look at
<pre>
import 'another_rakefile'

task :default do
  puts 'Default task'
end
</pre>
###How to install.
https://github.com/ruby/rake<br>
bundle install rake<br>
rake 

###How to use.
Navigate to repository directory in your terminal.<br>
folder acting upon requires subfolders and files in each folder.

Clone down the master repository you wish to modify into the "my_repositories" folder.<br>
In terminal, run rake submodulize_folder.

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
