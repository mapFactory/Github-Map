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
			check(recollect_github_credentials(credentials, type), type)
		else
			return credentials
		end
	#end
end
def inputsToUser(main_github = nil, secondary_github = nil, main_pass = nil, secondary_pass = nil)#parameters added would be void... hope is pass by ref.(master, junk)
	if main_github.nil?
		main_github 		= accountName("Github account name for master repository")
		secondary_github 	= accountName("Github account name for junk repositories")
		main_passs 			= accountPassword("password for master GitHub account")
		secondary_pass 		= accountPassword("password for secondary (junk) GitHub account")
	end

	
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
		puts `touch README.md`
	end
end
def Backup(environmentFolder, folder)
    Dir.chdir("#{environmentFolder}/") do |x|
        puts `cp -r #{folder} backup_#{folder}` # Copy never to be touched till end
    end
end
def initialize_submodule(folder, junk_account)
    # folder is full path to folder e.g.(github_repo_submodulizer/my_repositories/test/folder)
    folder_count = 0;
    Dir.chdir("#{folder}") do |i|
        create_Repo_From_subFolder(folder, junk_account)#still need setup remote repo... check on a json.
        #the above method calls establish_Origin repo.
	touchwithReadme(folder)
    end
    Dir.foreach(folder) do |x|
        # x is subfolder being operated on
        if(File.directory?("#{folder}/#{x}"))
            if !(x == ".." || x == "." || x == ".git")
                folder_count += 1
                initialize_submodule("#{folder}/#{x}", junk_account)
                Dir.chdir("#{folder}") do |i|
                    removeFiles_addSubmodule(x, junk_account)
                    commit_andPush(x)
                end
            end
        end
    end
    if folder_count == 0
        return 1;
    end
end
