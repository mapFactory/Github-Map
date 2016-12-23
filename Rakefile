require 'io/console'
require 'json'
def folderName()
	puts "Please enter folder name: "
	folder = STDIN.gets
end
def accountName(str)
	puts "Please enter #{str}: "
	username = STDIN.gets
end
def accountPassword(str)
	puts "Please enter #{str}: "
	password = STDIN.noecho(&:gets)
end
def establish_Origin_repo(folder, account)
#Dir.chdir("my_repositories/#{master_repo_dir}") do |x|
		puts `git remote rm origin`
 		#command hidden to hide credentials
 		`git remote add origin https://#{account[:user]}:#{account[:pass]}@github.com/#{account[:user]}/#{folder.split('/')[-1]}.git` 		
# 	 	`git remote add origin https://#{junk_account[:user]}:#{junk_account[:pass]}@github.com/#{junk_account[:user]}/#{folder.split('/')[-1]}.git`
end
#create subFolder as a Repo
#1_deliverable... is create repo on Github1
def create_Repo_From_subFolder(folder, account)
		puts `git init`
		puts `git add *`
 		puts `git commit -m "Initial Commit"`

 		# creates empty repo using name of given folder as repo name.
 		# folder name is collected by spliting "folder" and string after last "/"
 		puts `curl -u "#{account[:user]}:#{account[:pass]}" https://api.github.com/user/repos -d '{ "name": "#{folder.split('/')[-1]}" }'`
		establish_Origin_repo(folder, account)
		puts `git push origin master`
end
def checkM(main_github, main_pass) #master account
	#if(
	master = {user: main_github.gsub("\n", ""), pass: main_pass.gsub("\n", "")} 
		#)puts "incorrectMasterAccount or MasterAccount credentials"
		#masterAccountUserName()
	 	#masterAccountpassword()
		#checkM()
	#end
end
def checkJ(secondary_github,secondary_pass)#junk account
	#if(
	junk = {user: secondary_github.gsub("\n", ""), pass: secondary_pass.gsub("\n", "")}
		#)puts "incorrectMasterAccount or MasterAccount credentials"
		#junkAccountUserName()
		#junkAccountpassword()
		#checkJ()
	#end 
end
def inputsToUser()#parameters added would be void... hope is pass by ref.(master, junk)
	main_github 		= accountName("Github account name for master repository")
	secondary_github 	= accountName("Github account name for junk repositories")
	main_pass 			= accountPassword("password for master GitHub account")
	secondary_pass 		= accountPassword("password for secondary (junk) GitHub account")
	#handleFailures...
	master 	= checkM(main_github, main_pass)
	junk 	= checkJ(secondary_github,secondary_pass)
	#end handleFailures
	object = {j: junk, m: master}
end
#task created for testing purposes to show deleting of repo.
task :check_delete_repo do
	folder = folderName()
	object = inputsToUser()
######username = accountName("username")
######password = accountPassword("password")
	folder = folder.gsub("\n", "")
	#puts "#{object[:m][:user]}#{object[:m][:pass]}#{object[:j][:user]}#{object[:j][:pass]}"
	username = object[:m][:user]
	password = object[:m][:pass]#these two commands are for preliminary test purposes for this particular task.
######username = username.gsub("\n", "")
######password = password.gsub("\n", "")
	Dir.chdir("my_repositories/#{folder}") do |x|
		create_Repo_From_subFolder(folder, object[:m])
		`curl -u #{username}:#{password} -X DELETE  https://api.github.com/repos/{#{username}}/{#{folder}}`
		#`git remote rm origin`##establish_Origin_repo is now handling this section.
	end
end


task :deprecated_submodulize_folder do
	object = inputsToUser()
	puts "#{object[:m][:user]}#{object[:m][:pass]}#{object[:j][:user]}#{object[:j][:pass]}"
end
task :submodulize_folder do
#	object = inputsToUser()
#	puts "#{object['junk']}"
#	puts "#{object['master[:user]']}"	
	master = {user: main_github.gsub("\n", ""), pass: main_pass.gsub("\n", "")}
	junk = {user: secondary_github.gsub("\n", ""), pass: secondary_pass.gsub("\n", "")}
	master_repo_dir = master_repo_dir.gsub("\n", "")
	Dir.chdir("my_repositories/") do |x|
		puts `cp #{master_repo_dir} backup_#{master_repo_dir}` # Copy never to be touched till end
	end
	#Dir.mkdir("my_repositories/submodule_builder")
	Dir.chdir("my_repositories/#{master_repo_dir}") do |x|
		puts `git remote rm origin`
 		puts `git remote add origin https://#{master[:user]}:#{master[:pass]}@github.com/#{master[:user]}/#{x.split('/')[-1]}.git`
	end
	Dir.foreach("my_repositories/#{master_repo_dir}") do |x|
		if(File.directory?("my_repositories/#{master_repo_dir}/#{x}"))
			# Refactor possible
			if !(x == ".." || x == "." || x == ".git")
				 puts `mv my_repositories/#{master_repo_dir}/#{x} my_repositories/#{x}`#submodule_builder/#{x}`
				 initialize_submodule("my_repositories/#{x}", junk) #submodule_builder/#{x}", junk)
				 #if fails, check master credentials
				 Dir.chdir("my_repositories/#{master_repo_dir}") do |i|
				 	puts `git rm --cached -rf #{x}`
				 	puts `git submodule add https://github.com/#{junk[:user]}/#{x}`
				 end
				 while !Dir.exists?("my_repositories/#{master_repo_dir}/#{x}") do
				 	recollect_github_credentials(master, 'master')
				 	Dir.chdir("my_repositories/#{master_repo_dir}") do |i|
				 		puts `git submodule add https://github.com/#{junk[:user]}/#{x}`
				 	end
				 end
				 Dir.chdir("my_repositories/#{master_repo_dir}") do |i|
				 	puts `git rm --cached -rf #{x}`
				 	puts `git add *`
				 	puts `git commit -m "Add submodule folder #{x}"`
				 	puts `git push origin master`
				 end
			end
		end
	end
	# puts `sudo rm -rf my_repositories/submodule_builder`
end
def initialize_submodule(folder, junk_account)
	# folder is full path to folder e.g.(github_repo_submodulizer/my_repositories/test/folder)
	Dir.chdir("#{folder}") do |i|
		puts `git init`
		puts `git add *`
 		puts `git commit -m "Initial Commit"`
 		#if fails to create empty repo, check junk credentials
 		while !setup_remote_repo(junk_account, folder.split('/')[-1]) do
 			junk_account = recollect_github_credentials(junk_account, 'junk')
 		end
 		#puts `curl -u "#{junk_account[:user]}:#{junk_account[:pass]}" https://api.github.com/user/repos -d '{ "name": "#{folder.split('/')[-1]}" }'`
 		puts `git remote rm origin`
 		#command hidden to hide credentials
 		 `git remote add origin https://#{junk_account[:user]}:#{junk_account[:pass]}@github.com/#{junk_account[:user]}/#{folder.split('/')[-1]}.git`
 		puts `git push origin master`
	end
	#This will fail if there are no files or folders
	#If folder contains nothing, touch a file to it
	if Dir["#{folder}/*"].empty?
		Dir.chdir("#{folder}") do |i|
			puts `touch README.md`
		end
	end
	Dir.foreach(folder) do |x|
		# x is subfolder being operated on
		if(File.directory?("#{folder}/#{x}"))
			if !(x == ".." || x == "." || x == ".git")
				 initialize_submodule("#{folder}/#{x}", junk_account)
				 Dir.chdir("#{folder}") do |i|
				 	puts `git rm --cached -rf #{x}`
				 	puts `git submodule add https://github.com/#{junk_account[:user]}/#{x}`
				 	puts `git rm --cached -rf #{x}`
				 	puts `git add *`
				 	puts `git commit -m "Add submodule folder #{x}"`
				 	puts `git push origin master`
				 end
			end
		end
	end
end
def setup_remote_repo(account, name)
	# creates empty repo using name of given folder as repo name.
 		# folder name is collected by spliting "folder" and string after last "/"
	puts `curl -u "#{account[:user]}:#{account[:pass]}" https://api.github.com/user/repos -d '{ "name": "#{name}" }'`
	repo_check = JSON.parse(`curl https://api.github.com/repos/#{account[:user]}/#{name}`)
	return repo_check["message"].nil?
end
def recollect_github_credentials(account, type)
	puts "Account credentials for #{account[:user]} (#{type} account) invalid."
	puts "Username: "
	username = STDIN.gets
	puts "Password: "
	password = STDIN.noecho(&:gets)
	new_account = {user: username.gsub("\n", ""), pass: password.gsub("\n", "")}
	return new_account
end
