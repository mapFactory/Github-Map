require 'io/console'
require 'json'
require_relative 'inputs.rb'
require_relative 'repo_finder.rb'
require_relative 'backup.rb'
require_relative 'environment.rb'
require_relative 'navigation.rb'
require_relative 'update.rb'

#production Tasks
task :update_submodule_folder_history do
	object = inputsToUser()
	update_repository("my_repositories", object, type = 'master')
end 
task :Github_Map do #works
	object = Inputs.inputsToUser()
	Navigator.automate("my_repositories", object, exist = true, type = 'master')
end
task :deGithub_Map do
	object = Inputs.inputsToUser()
	Navigator.automate("my_repositories", object, exist = false, type= 'master')
end

#test Tasks
task :test_Github_Map do
	#folder1 = "1_test_CheckReadmeAndSubdirs"#folder1; #folder1				= "new_folder";#folder1				= "2_test_MasterReponoSub"; #folder1				= "e_test_NoReadme"
	#object = inputsToUser("miketestgit02", "miketestgit02", "qzfreetf59im", "qzfreetf59im")
	object = Inputs.inputsToUser("1_test_CheckReadmeAndSubdirs" ,master = {user: "miketestgit02", pass: "qzfreetf59im"},junk = {user: "miketestgit02", pass: "qzfreetf59im"})
	Navigator.automate("Testing",object, exist = true, type= 'junk')
end
task :test_deGithub_Map do
	object = Inputs.inputsToUser("1_test_CheckReadmeAndSubdirs", master = {user: "miketestgit02", pass: "qzfreetf59im"},junk = {user: "miketestgit02", pass: "qzfreetf59im"})
	Navigator.automate("Testing",object, exist = false, type= 'junk')
end
