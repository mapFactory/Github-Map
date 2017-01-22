def folderName(folder = nil) puts "Please enter folder name: "; folder = STDIN.gets; folder = folder.gsub("\n", ""); end #called specifically in task
def accountName(str) puts "Please enter Github account name for #{str} repository: "; username = STDIN.gets; username.gsub("\n", ""); end #inputsToUser
def accountPassword(str) puts "Please enter password for #{str} Github account: "; password = STDIN.noecho(&:gets); password.gsub("\n", ""); end #inputsToUser
def recollect_github_credentials(account, type, new_credentials = nil)
	puts "Account credentials for #{account[:user]} (#{type} account) invalid."
	if(new_credentials.nil?)
		puts "Username: ";username = STDIN.gets
		puts "Password: ";password = STDIN.noecho(&:gets)
	else
		username = new_credentials[:user]
		password = new_credentials[:pass]
	end
	return {user: username.gsub("\n", ""), pass: password.gsub("\n", "")}
end
def check(credentials, type, new_credentials = nil)
	response = `curl -i https://api.github.com -u #{credentials[:user]}:#{credentials[:pass]}`
	response = JSON.parse(response[response.index('{')..-1])
	response["message"] ? check(recollect_github_credentials(credentials, type, new_credentials), type) : credentials
end
def check_remote_exists(account, folder)
	#account = (type == "master" ? object[:m] : object[:j])
	response = `curl -i https://api.github.com/repos/#{account[:user]}/#{folder}`
	response = JSON.parse(response[response.index('{')..-1])
	response["message"].nil?
end
def inputsToUser(folder = nil, master = nil, junk = nil)
	if folder.nil? && master.nil? && junk.nil?
		folder = folderName()
		master = {user: accountName("master"), pass: accountPassword("master")}
		junk = {user: accountName("junk"), pass: accountPassword("junk")}
	end
	return {f: folder, j: check(junk, 'junk'), m: check(master, 'master')}
end#parameters added would be void... hope is pass by ref.(master, junk)
def establish_Origin_repo(folder, account)
		puts `git remote rm origin`
 		`git remote add origin https://#{account[:user]}:#{account[:pass]}@github.com/#{account[:user]}/#{folder.split('/')[-1]}.git`
end #do not puts anything that shows credentials		
def create_Repo_From_subFolder(folder, account)
		puts `git init`;puts `git add *`;puts `git commit -m "Initial Commit"`;
 		`curl -u "#{account[:user]}:#{account[:pass]}" https://api.github.com/user/repos -d '{ "name": "#{folder.split('/')[-1]}" }' /dev/null`
		if check_remote_exists(account, folder.split('/')[-1])
			establish_Origin_repo(folder, account)
			`git push origin master --quiet`
		else
			puts "Failed to create remote repo for #{folder}."
		end
		#check_remote_exist() *check remote exists here* warning: adds additional ping
		#puts folder
		
end# creates empty repo using name of given folder as repo name.# folder name is collected by spliting "folder" and string after last "/"
def commit_andPush(x)
	puts `git rm --cached -rf #{x}`
	puts `git add *`;`git commit -m "Add submodule folder #{x}"`;`git push origin master --quiet`
end
def removeFiles_addSubmodule(x, junk)
	puts `git rm --cached -rf #{x}`
	puts `git submodule add https://github.com/#{junk[:user]}/#{x}`
end
def touchwithReadme(folder)
	if Dir["#{folder}/*"].empty?
		puts `touch README.md`
	end
end
def submodule_backup(environmentFolder, folder)
	Dir.chdir("#{environmentFolder}/") do |x|
    	if File.directory?("submodulebackup_#{folder}")
    		puts `rm -rf submodulebackup_#{folder}`
    	end
    	puts `cp -r #{folder} submodulebackup_#{folder}` 
    end
end
def Backup(environmentFolder, folder)
    Dir.chdir("#{environmentFolder}/") do |x|
    	if !File.directory?("backup_#{folder}")
    		puts `cp -r #{folder} backup_#{folder}` 
    	end
    end
end# Copy never to be touched till end... if copy already exists it should be ignored or copy itself not be overridden
def Delete_Backup(environmentFolder, folder)
    Dir.chdir("#{environmentFolder}/") do |x|
        puts `rm -rf backup_#{folder}` 
    end
end
def delete_online_repo(folder, account)
	username = account[:user];password = account[:pass];
	`curl -u #{username}:#{password} -X DELETE  https://api.github.com/repos/{#{username}}/{#{folder.split('/')[-1]}}`;#puts folder.split('/')[-1];
end
def surface_folder_level(folder, account, exist)
	Dir.chdir("#{folder}") do |i| #current_directory()
		if exist
			touchwithReadme(folder)
			create_Repo_From_subFolder(folder, account)
		else
			delete_online_repo(folder, account)
		end
	end
end
def sub_folder_level(folder, object, exist)
	Dir.foreach(folder) do |x|
		if(File.directory?("#{folder}/#{x}"))
      			if !(x == ".." || x == "." || x == ".git") #sub_directories()
                		initialize_submodule("#{folder}/#{x}", object, exist, 'junk')
                		if exist
                			Dir.chdir("#{folder}") do |i|
                    				removeFiles_addSubmodule(x, object[:j])
                    				commit_andPush(x)
end	end	end 	end 	end	end
def master_has_subfolders_or_is_subfolder_already(folder, type)#subfolder would mean that type is "junk"
	if type == "master"
		Dir.foreach(folder) do |x|
			if(File.directory?("#{folder}/#{x}"))
	      			if !(x == ".." || x == "." || x == ".git") #sub_directories()
	                		return 2
		end	end	end
	else
		return true
	end
	#if the return has not happened by now it is presumably false.
end
def initialize_submodule(folder, object, exist, type)
	if master_has_subfolders_or_is_subfolder_already(folder, type)
		account = (type == "master" ? object[:m] : object[:j])
		# check_repo_exist(account)if_object[j]
		surface_folder_level(folder, account, exist)
		sub_folder_level(folder, object, exist)
	else puts "No subfolders found in this repository. No actions were taken."
end	end# folder is full path to folder e.g.(github_repo_submodulizer/my_repositories/test/folder)
def check_local_directory_exists(environmentFolder, object)
		if(!File.directory?("#{environmentFolder}/#{object[:f]}"))
        	puts "did not find file #{object[:f]}"
        	object[:f] = folderName(object[:f])
        	clone_master(environmentFolder, object)
    	end
end
def clone_master(environmentFolder, object)
	if check_remote_exists(object[:m], object[:f])#if it was online... rm folder if exists and clone it down.
		Dir.chdir("#{environmentFolder}") do
			puts `rm -rf #{object[:f]}`
			puts `git clone --recursive https://github.com/#{object[:m][:user]}/#{object[:f]}`
		end 
	else 
		check_local_directory_exists("#{environmentFolder}", object)
	end
end
def automate(environmentFolder, object, exist, type)
	if exist 
		clone_master("#{environmentFolder}", object)
		Backup(environmentFolder, object[:f]) 
	end	
	initialize_submodule("#{environmentFolder}/#{object[:f]}", object, exist, type)
	submodule_backup(environmentFolder, object[:f])
end
