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

###layout
<pre>
submodulizeFolder()
  eachSubDir()
     initializeSubmodule()
      eachSubDir()
        initializeSubmodule()
</pre>
Copyright (c) 2017, Ryan Murphy and Michael Dimmitt
