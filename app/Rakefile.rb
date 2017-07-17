require 'io/console'
require 'json'
require_relative 'src/inputs.rb'
require_relative 'src/backup.rb'
require_relative 'src/app_controller.rb'
require_relative 'src/update.rb'

#production Tasks
task :update_submodule_folder_history do
	object = inputsToUser()
	update_repository("my_repositories", object, type = 'master')
end
task :github_map do #works
	object = Inputs.inputsToUser()
	AppController.automate("my_repositories", object, exist = true, type = 'master')
end
task :de_github_map do
	object = Inputs.inputsToUser()
	AppController.automate("my_repositories", object, exist = false, type= 'master')
end

#demo Tasks
task :demo_github_map do
	`cd ../Testing; git clone https://github.com/ArnoldM904/Random_Programs.git;`
	object = Inputs.inputsToUser("Random_Programs" ,master = {user: "miketestgit02", pass: "qzfreetf59im"},junk = {user: "miketestgit02", pass: "qzfreetf59im"})
	AppController.automate("Testing",object, exist = true, type= 'junk')
end
task :demo_de_github_map do
	object = Inputs.inputsToUser("Random_Programs" ,master = {user: "miketestgit02", pass: "qzfreetf59im"},junk = {user: "miketestgit02", pass: "qzfreetf59im"})
	AppController.automate("Testing",object, exist = false, type= 'junk')
end

#test Tasks`
task :test_github_map do
	object = Inputs.inputsToUser("1_test_CheckReadmeAndSubdirs" ,master = {user: "miketestgit02", pass: "qzfreetf59im"},junk = {user: "miketestgit02", pass: "qzfreetf59im"})
	AppController.automate("Testing",object, exist = true, type= 'junk')
end
task :test_de_github_map do
	object = Inputs.inputsToUser("1_test_CheckReadmeAndSubdirs", master = {user: "miketestgit02", pass: "qzfreetf59im"},junk = {user: "miketestgit02", pass: "qzfreetf59im"})
	AppController.automate("Testing",object, exist = false, type= 'junk')
end
