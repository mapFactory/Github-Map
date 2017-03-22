require 'io/console'
require 'json'
require_relative 'inputs.rb'
require_relative 'repo_finder.rb'
require_relative 'backup.rb'
require_relative 'environment.rb'
require_relative 'navigation.rb'
#Live tasks
task :Test_printInputs do object = Inputs.inputsToUser();puts "#{object[:m][:user]}#{object[:m][:pass]}#{object[:j][:user]}#{object[:j][:pass]}"; end
task :check_delete_repo do #task created for testing purposes to show deleting of repo.
	folder = Inputs.folderName()
	object = Inputs.inputsToUser()#check is inside inputs()
	folder = folder.gsub("\n", "")#should this be inside folderName()?
	Dir.chdir("my_repositories/#{folder}") do |x|
		environment = Environment.new
		environment.create_Repo_From_subFolder(folder, object[:m])
		`curl -u #{object[:m][:user]}:#{object[:m][:pass]} -X DELETE  https://api.github.com/repos/{#{object[:m][:user]}}/{#{folder}}`
	end
end
task :test_check_delete_repo do
	folder = Inputs.folderName
	object = Inputs.inputsToUser("miketestgit02", "miketestgit02", "qzfreetf59im", "qzfreetf59im")#check is inside inputs()
	folder = folder.gsub("\n", "")
	username = object[:m][:user]
	password = object[:m][:pass]#these two commands are for preliminary test purposes for this particular task.
	Dir.chdir("my_repositories/#{folder}") do |x|
		environment = Environment.new
		environment.create_Repo_From_subFolder(folder, object[:m])
		`curl -u #{username}:#{password} -X DELETE  https://api.github.com/repos/{#{username}}/{#{folder}}`
	end
end
task :update_submodule_backup do
	folder = Inputs.folderName
	Backups.submodule_backup("my_repositories", folder)
end
task :submodulize_folder do
	object = Inputs.inputsToUser()
	Navigator.automate("my_repositories", object, exist = true, type = 'master')
end
task :desubmodulize_folder do
	object = inputsToUser()
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
