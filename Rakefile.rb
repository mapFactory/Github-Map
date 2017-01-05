require 'io/console'
require 'json'

def folderName() puts "Please enter folder name: "; folder = STDIN.gets; end #called specifically in task
def accountName(str) puts "Please enter #{str}: "; username = STDIN.gets; end #inputsToUser
def accountPassword(str) puts "Please enter #{str}: "; password = STDIN.noecho(&:gets); end #inputsToUser
def recollect_github_credentials(account, type)
	puts "Account credentials for #{account[:user]} (#{type} account) invalid."
	puts "Username: ";username = STDIN.gets
	puts "Password: ";password = STDIN.noecho(&:gets)
	new_account = {user: username.gsub("\n", ""), pass: password.gsub("\n", "")}
	return new_account
end
def check(credentials, type)
	#if !credentials.nil?
		response = `curl -i https://api.github.com -u #{credentials[:user]}:#{credentials[:pass]}`
		response = JSON.parse(response[response.index('{')..-1])
		if response["message"]
			puts "Incorrect #{type} account or credentials"
			check(recollect_account_credentials(credentials, type), type)
		end
	#end
end
task :check_credentials do #task used to check validity of Github credentials.
	# collect_account_credentials('master')
	# collect_account_credentials('junk')
	# check(@master, 'master')
	# check(@junk, 'junk')
end
task :check_delete_repo do #task created for testing purposes to show deleting of repo.
	folder = folderName()
	object = inputsToUser()#check is inside inputs()
	folder = folder.gsub("\n", "")
	username = object[:m][:user]
	password = object[:m][:pass]#these two commands are for preliminary test purposes for this particular task.
	Dir.chdir("my_repositories/#{folder}") do |x|
		create_Repo_From_subFolder(folder, object[:m])
		`curl -u #{username}:#{password} -X DELETE  https://api.github.com/repos/{#{username}}/{#{folder}}`
	end
end
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
	end
end
def doStuff(environmentFolder, folder, master, junk)
	master_repo_dir = folder.gsub("\n", "")
	Dir.chdir("#{environmentFolder}/") do |x|
		puts `cp -r #{master_repo_dir} backup_#{master_repo_dir}` # Copy never to be touched till end
	end
	Dir.chdir("#{environmentFolder}/#{master_repo_dir}") do |x|
		#puts `git remote rm origin`
		`git init`
 		puts `git remote add origin https://#{master[:user]}:#{master[:pass]}@github.com/#{master[:user]}/#{x.split('/')[-1]}.git`
	end
	Dir.foreach("#{environmentFolder}/#{master_repo_dir}") do |x|
		if(File.directory?("#{environmentFolder}/#{master_repo_dir}/#{x}"))
			# Refactor possible
			if !(x == ".." || x == "." || x == ".git")
				 initialize_submodule("#{environmentFolder}/#{master_repo_dir}/#{x}", junk)
				 Dir.chdir("#{environmentFolder}/#{master_repo_dir}") do |i|
				 	removeFiles_addSubmodule(x, junk)
				 	commit_andPush(x)
				 end
			end
		end
	end
end
task :submodulize_folder do
	folder = folderName()
	object = inputsToUser()
	doStuff('my_repositories',folder, object[:m], object[:j])
end
#tests Methods
#tests Tasks
task :test_submodulize_folder do
	#folder1				= "new_folder"
	folder1			= "1_test_CheckReadmeAndSubdirs"#folder1
	folder2				= "2_test_MasterReponoSub"
	folder3				= "e_test_NoReadme"
	main_github 		= "miketestgit02"
	secondary_github	= "miketestgit02"
	main_pass 			= "qzfreetf59im"
	secondary_pass 		= "qzfreetf59im"
	master = {user: main_github.gsub("\n", ""), pass: main_pass.gsub("\n", "")}
	junk = {user: secondary_github.gsub("\n", ""), pass: secondary_pass.gsub("\n", "")}
	doStuff('Testing', folder1, master, junk)
end
task :Test_printInputs do
	object = inputsToUser()
	puts "#{object[:m][:user]}#{object[:m][:pass]}#{object[:j][:user]}#{object[:j][:pass]}"
end
#task used to check validity of Github credentials.
task :test_check_credentials do
puts "test currently does nothing, code has been commented out. Modify to make this test work."
#	collect_account_credentials('master')
#	collect_account_credentials('junk')
#	check(@master, 'master')
#	check(@junk, 'junk')
end
#task created for testing purposes to show deleting of repo.
task :test_check_delete_repo do
	folder = folderName()#hardcode...
	object = inputsToUser()#hardcode...
	folder = folder.gsub("\n", "")
	username = object[:m][:user]
	password = object[:m][:pass]#these two commands are for preliminary test purposes for this particular task.
	Dir.chdir("Testing/#{folder}") do |x|
		create_Repo_From_subFolder(folder, object[:m])
		`curl -u #{username}:#{password} -X DELETE  https://api.github.com/repos/{#{username}}/{#{folder}}`
		#`git remote rm origin`##establish_Origin_repo is now handling this section.
	end
end
