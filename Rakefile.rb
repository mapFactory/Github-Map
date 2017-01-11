<<<<<<< HEAD
task :create_remote_repo do
	ruby "create_repository.rb"
end

task :create_local_repo, [:master_repo_dir] do |t, args|

	if !(File.directory?("my_repositories/#{args[:master_repo_dir]}"))
		Dir.mkdir("my_repositories/#{args[:master_repo_dir]}")
	end

	Dir.chdir("my_repositories/#{args[:master_repo_dir]}") do
		puts `git init`
	end
end

# task :clone_remote_repo do
# 	exec("python cloner_with_repo_name.py")
# end

task :add_submodule, [:master_repo_dir, :sub_user, :sub_repo_name] do |t, args|
	Dir.chdir("my_repositories/#{args[:master_repo_dir].gsub!(/\A"|"\Z/, '')}") do
		`git submodule add https://github.com/#{args[:sub_user].gsub!(/\A"|"\Z/, '')}/#{args[:sub_repo_name].gsub!(/\A"|"\Z/, '')}`
	end
end

task :create_sub_repos, [:master_repo_dir, :github_user] do |t, args|
	Dir.foreach("my_repositories/#{args[:master_repo_dir]}") do |x|

		if File.directory?("my_repositories/#{args[:master_repo_dir]}/#{x}")
			if !(x == ".." || x == "." || x == ".git")
				 Dir.chdir("my_repositories/#{args[:master_repo_dir]}/#{x}") do

				 	puts `git init`
				 	puts `git add *`
				 	puts `git commit -m "Initial Commit"`
				 	puts `curl -u #{args[:github_user]} https://api.github.com/user/repos -d '{ "name": "#{x}" }'`
				 	puts `git remote add origin https://github.com/#{args[:github_user]}/#{x}.git`
				 	puts `git push origin master`

				 	Dir.chdir("..") do
				 		puts `git submodule add https://github.com/#{args[:github_user]}/#{x}.git`
				 	end
				 	
				 end
			end
		end
=======
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
<<<<<<< HEAD
<<<<<<< HEAD
def inputsToUser()#parameters added would be void... hope is pass by ref.(master, junk)
	main_github 		= accountName("Github account name for master repository")
	secondary_github 	= accountName("Github account name for junk repositories")
	main_pass 			= accountPassword("password for master GitHub account")
	secondary_pass 		= accountPassword("password for secondary (junk) GitHub account")
	#handleFailures...
	# master 	= check(main_github, main_pass)
	# junk 	= check(secondary_github,secondary_pass)
	master = {user: main_github.gsub("\n", ""), pass: main_pass.gsub("\n", "")}
	junk = {user: secondary_github.gsub("\n", ""), pass: secondary_pass.gsub("\n", "")}

	master = check(master, 'master')
	junk = check(junk, 'junk')
	#end handleFailures
	object = {j: junk, m: master}
end
def setup_remote_repo(account, name)
	# posts an empty repo to github.
	puts `curl -u "#{account[:user]}:#{account[:pass]}" https://api.github.com/user/repos -d '{ "name": "#{name}" }'`
	repo_check = JSON.parse(`curl https://api.github.com/repos/#{account[:user]}/#{name}`)
	return repo_check["message"].nil?
end
def establish_Origin_repo(folder, account)
		#do not puts anything that shows credentials
		puts `git remote rm origin`
 		`git remote add origin https://#{account[:user]}:#{account[:pass]}@github.com/#{account[:user]}/#{folder.split('/')[-1]}.git`
end
def create_Repo_From_subFolder(folder, account)
		puts `git init`;puts `git add *`;puts `git commit -m "Initial Commit"`;
 		# creates empty repo using name of given folder as repo name.# folder name is collected by spliting "folder" and string after last "/"
 		`curl -u "#{account[:user]}:#{account[:pass]}" https://api.github.com/user/repos -d '{ "name": "#{folder.split('/')[-1]}" }'`
		establish_Origin_repo(folder, account)
		`git push origin master --quiet`
end
def commit_andPush(x)
	puts `git rm --cached -rf #{x}`
	puts `git add *`
	`git commit -m "Add submodule folder #{x}"`
	`git push origin master --quiet`
end
def removeFiles_addSubmodule(x, junk)
	puts `git rm --cached -rf #{x}`
	puts `git submodule add https://github.com/#{junk[:user]}/#{x}`
end
def touchwithReadme(folder)
	if Dir["#{folder}/*"].empty?
		Dir.chdir("#{folder}") do |i|
			puts `touch README.md`
		end
	end
end
def initialize_submodule(folder, junk_account)
	# folder is full path to folder e.g.(github_repo_submodulizer/my_repositories/test/folder)
	Dir.chdir("#{folder}") do |i|
		create_Repo_From_subFolder(folder, junk_account)#still need setup remote repo... check on a json.
		#the above method calls establish_Origin repo.
	end
	#this should be a method... above in this method needs refactor first.
	#This will fail if there are no files or folders
	#If folder contains nothing, touch a file to it
	touchwithReadme(folder)
	Dir.foreach(folder) do |x|
		# x is subfolder being operated on
		if(File.directory?("#{folder}/#{x}"))
			if !(x == ".." || x == "." || x == ".git")
				 initialize_submodule("#{folder}/#{x}", junk_account)
				 Dir.chdir("#{folder}") do |i|
				 	removeFiles_addSubmodule(x, junk_account)
				 	commit_andPush(x)
				 end
			end
		end
<<<<<<< HEAD
		
>>>>>>> 53bb2ce... Create task for converting all directories and subdirectories to submodules
=======
>>>>>>> 5608e51... Update Rakefile
	end
end
def doStuff(environmentFolder, folder, master, junk)
	master_repo_dir = folder.gsub("\n", "")
	folder_count = 0
	Dir.chdir("#{environmentFolder}/") do |x|
		puts `cp -r #{master_repo_dir} backup_#{master_repo_dir}` # Copy never to be touched till end
	end
	Dir.chdir("#{environmentFolder}/#{master_repo_dir}") do |x|
		create_Repo_From_subFolder(folder, master)
	end
	Dir.foreach("#{environmentFolder}/#{master_repo_dir}") do |x|
		if(File.directory?("#{environmentFolder}/#{master_repo_dir}/#{x}"))
			# Refactor possible
			if !(x == ".." || x == "." || x == ".git")
				folder_count += 1
				 initialize_submodule("#{environmentFolder}/#{master_repo_dir}/#{x}", junk)
				 Dir.chdir("#{environmentFolder}/#{master_repo_dir}") do |i|
				 	removeFiles_addSubmodule(x, junk)
				 	commit_andPush(x)
				 end
			end
		end
	end
	if folder_count == 0
		puts "No subfolders found in this repository. No actions were taken."
	end
end
=======
>>>>>>> 0b409d0... Reduce Rakefile to tasks only
=======
task :delete_submodulize_folder do
	folder1 = folderName()
	object = inputsToUser()
	initialize_submodule("my_repositories/#{folder1}", object, 1, 'master')
end
>>>>>>> b41290b... both working; added methods submodulize_folder() and delete_submodulize_folder()
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
    object = inputsToUser({user: "miketestgit02", pass: "qzfreetf59im"}, {user: "miketestgit02", pass: "qzfreetf59im"})
    Backup('Testing', folder1)
    folder_count = initialize_submodule("Testing/#{folder1}", object, 0, 'junk')#doStuff('Testing', folder1, object[:m], object[:j])
    if (folder_count == 1) then puts "No subfolders found in this repository. No actions were taken." end
end
task :test_delete_all do
	folder1	= "1_test_CheckReadmeAndSubdirs";folder2 = "2_test_MasterReponoSub";folder3	= "e_test_NoReadme";	#folder1 = "new_folder"
	object = inputsToUser("miketestgit02", "miketestgit02", "qzfreetf59im", "qzfreetf59im")
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
