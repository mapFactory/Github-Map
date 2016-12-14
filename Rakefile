require 'io/console'

task :submodulize_folder do
	puts "Please enter the name of the master folder"
	master_repo_dir = STDIN.gets
	puts "Please enter Github account name for master repository"
	main_github = STDIN.gets
	puts "Please enter Github account name for junk repositories"
	secondary_github = STDIN.gets
	puts "Please enter password for master GitHub account:"
	main_pass = STDIN.noecho(&:gets)
	puts "Please enter password for secondary (junk) GitHub account:"
	secondary_pass = STDIN.noecho(&:gets)

	master = {user: main_github.gsub("\n", ""), pass: main_pass.gsub("\n", "")}
	junk = {user: secondary_github.gsub("\n", ""), pass: secondary_pass.gsub("\n", "")}

	master_repo_dir = master_repo_dir.gsub("\n", "")

	Dir.mkdir("my_repositories/submodule_builder")

	Dir.chdir("my_repositories/#{master_repo_dir}") do |x|
		puts `git remote rm origin`
 		puts `git remote add origin https://#{master[:user]}:#{master[:pass]}@github.com/#{master[:user]}/#{x.split('/')[-1]}.git`
	end

	Dir.foreach("my_repositories/#{master_repo_dir}") do |x|
		if(File.directory?("my_repositories/#{master_repo_dir}/#{x}"))
			# Refactor possible
			if !(x == ".." || x == "." || x == ".git")
				 puts `mv my_repositories/#{master_repo_dir}/#{x} my_repositories/submodule_builder/#{x}`
				 initialize_submodule("my_repositories/submodule_builder/#{x}", junk)

				 Dir.chdir("my_repositories/#{master_repo_dir}") do |i|
				 	puts `git rm --cached -rf #{x}`
				 	puts `git submodule add https://github.com/#{junk[:user]}/#{x}`
				 	puts `git rm --cached -rf #{x}`
				 	puts `git add *`
				 	puts `git commit -m "Add submodule folder #{x}"`
				 	puts `git push origin master`
				 end
				 
			end
		end
	end

	puts `sudo rm -rf my_repositories/submodule_builder`



end



# def checkDir(folder)
# 	Dir.foreach(folder) do |x|
# 		checkDir(x)

# 	end
# end

def initialize_submodule(folder, junk_account)

	# folder is full path to folder e.g.(github_repo_submodulizer/my_repositories/test/folder)
	Dir.chdir("#{folder}") do |i|
		puts `git init`
		puts `git add *`
 		puts `git commit -m "Initial Commit"`

 		# creates empty repo using name of given folder as repo name.
 		# folder name is collected by spliting "folder" and string after last "/"
 		puts `curl -u "#{junk_account[:user]}:#{junk_account[:pass]}" https://api.github.com/user/repos -d '{ "name": "#{folder.split('/')[-1]}" }'`
 		puts `git remote rm origin`
 		#command hidden to hide credentials
 		 `git remote add origin https://#{junk_account[:user]}:#{junk_account[:pass]}@github.com/#{junk_account[:user]}/#{folder.split('/')[-1]}.git`
 		puts `git push origin master`

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