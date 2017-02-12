require_relative 'environment.rb'
class Navigatior
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
		# if exist && type == "master"
		# 	clone_master(folder.split('/').first, object)
		# 	Backup(folder.split('/').first, object[:f])
		# 	set_submodulized(folder.split('/').first, folder.split('/')[-1]) 
		# end
		# if !exist && type == "master"
		# 	unset_submodulized(folder.split('/').first, folder.split('/')[-1]) 
		# end
		if master_has_subfolders_or_is_subfolder_already(folder, type)
			account = (type == "master" ? object[:m] : object[:j])
			# check_repo_exist(account)if_object[j]
			surface_folder_level(folder, account, exist)
			sub_folder_level(folder, object, exist)
		else puts "No subfolders found in this repository. No actions were taken."
	end	end# folder is full path to folder e.g.(github_repo_submodulizer/my_repositories/test/folder)
	
	def self.automate(environmentFolder, object, exist, type)
		#Below logic needs to be refactored
		environment = Environment.new
		if (exist && !environment.check_submodulized(environmentFolder, object[:f])) || (!exist && environment.check_submodulized(environmentFolder, object[:f]))
			if exist
				object = Repo_Finder.confirm_folder_exists(environmentFolder, object)
				#Repo_Finder.clone_master(environmentFolder, object)
				Backups.Backup(environmentFolder, object[:f])
				environment.set_submodulized(environmentFolder, object[:f]) 
			else
				environment.unset_submodulized(environmentFolder, object[:f]) 
			end

			environment.initialize_submodule("#{environmentFolder}/#{object[:f]}", object, exist, type)
			Backups.submodule_backup(environmentFolder, object[:f])
		else
			puts "Folder is already submodulized. No actions taken."
		end
		
	end

end