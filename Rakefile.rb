require 'io/console'
require 'json'
require_relative 'methods.rb'
#Live tasks
task :check_delete_repo do #task created for testing purposes to show deleting of repo.
	folder = folderName()
	object = inputsToUser()#check is inside inputs()
	folder = folder.gsub("\n", "")#should this be inside folderName()?
	Dir.chdir("my_repositories/#{folder}") do |x|
		create_Repo_From_subFolder(folder, object[:m])
		`curl -u #{object[:m][:user]}:#{object[:m][:pass]} -X DELETE  https://api.github.com/repos/{#{object[:m][:user]}}/{#{folder}}`
	end
end
task :delete_submodulize_folder do
	folder1 = folderName()
	object = inputsToUser()
	initialize_submodule("my_repositories/#{folder1}", object, 1, 'master')
end
task :submodulize_folder do
	folder1 = folderName()
	object = inputsToUser()
	initialize_submodule("my_repositories/#{folder1}", object, 0, 'master')
end
#test Tasks
task :Test_printInputs do object = inputsToUser();puts "#{object[:m][:user]}#{object[:m][:pass]}#{object[:j][:user]}#{object[:j][:pass]}"; end
task :test_submodulize_folder do
    folder1 = "1_test_CheckReadmeAndSubdirs"#folder1; #folder1				= "new_folder";#folder1				= "2_test_MasterReponoSub"; #folder1				= "e_test_NoReadme"
    #object = inputsToUser("miketestgit02", "miketestgit02", "qzfreetf59im", "qzfreetf59im")
    object = inputsToUser(master = {user: "miketestgit02", pass: "qzfreetf59im"},junk = {user: "miketestgit02", pass: "qzfreetf59im"})
    Backup('Testing', folder1)
    folder_count = initialize_submodule("Testing/#{folder1}", object, 0, 'junk')#doStuff('Testing', folder1, object[:m], object[:j])
    if (folder_count == 1) then puts "No subfolders found in this repository. No actions were taken." end
end
task :test_delete_all do
	folder1	= "1_test_CheckReadmeAndSubdirs";folder2 = "2_test_MasterReponoSub";folder3	= "e_test_NoReadme";	#folder1 = "new_folder"
	object = inputsToUser(master = {user: "miketestgit02", pass: "qzfreetf59im"},junk = {user: "miketestgit02", pass: "qzfreetf59im"})
    folder_count = initialize_submodule("Testing/#{folder1}", object, 1, 'junk')
    if (folder_count == 1) then puts "No subfolders found in this repository. No actions were taken."
    else Delete_Backup('Testing', folder1) end
end
task :test_check_delete_repo do
	folder = folderName()
	object = inputsToUser("miketestgit02", "miketestgit02", "qzfreetf59im", "qzfreetf59im")#check is inside inputs()
	folder = folder.gsub("\n", "")
	username = object[:m][:user]
	password = object[:m][:pass]#these two commands are for preliminary test purposes for this particular task.
	Dir.chdir("my_repositories/#{folder}") do |x|
		create_Repo_From_subFolder(folder, object[:m])
		`curl -u #{username}:#{password} -X DELETE  https://api.github.com/repos/{#{username}}/{#{folder}}`
	end
end
