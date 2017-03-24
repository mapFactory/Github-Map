require 'io/console'
require 'json'
require_relative 'inputs.rb'
require_relative 'repo_finder.rb'
require_relative 'backup.rb'
require_relative 'environment.rb'
require_relative 'navigation.rb'

#production Tasks
task :submodulize_folder do #works
	object = Inputs.inputsToUser()
	Navigator.automate("my_repositories", object, exist = true, type = 'master')
end
task :desubmodulize_folder do
	object = Inputs.inputsToUser()
	Navigator.automate("my_repositories", object, exist = false, type= 'master')
end

#test Tasks
task :test_submodulize_folder do
	#folder1 = "1_test_CheckReadmeAndSubdirs"#folder1; #folder1				= "new_folder";#folder1				= "2_test_MasterReponoSub"; #folder1				= "e_test_NoReadme"
	#object = inputsToUser("miketestgit02", "miketestgit02", "qzfreetf59im", "qzfreetf59im")
	object = Inputs.inputsToUser("1_test_CheckReadmeAndSubdirs" ,master = {user: "miketestgit02", pass: "qzfreetf59im"},junk = {user: "miketestgit02", pass: "qzfreetf59im"})
	Navigator.automate("Testing",object, exist = true, type= 'junk')
end
task :test_desubmodulize_folder do
	object = Inputs.inputsToUser("1_test_CheckReadmeAndSubdirs", master = {user: "miketestgit02", pass: "qzfreetf59im"},junk = {user: "miketestgit02", pass: "qzfreetf59im"})
	Navigator.automate("Testing",object, exist = false, type= 'junk')
end
