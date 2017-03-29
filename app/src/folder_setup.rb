require_relative 'inputs.rb'
class Folder_Setup
	
#discuss another day... this is currently not returning object rather true false.	
# -- def self.confirm_folder_exists(folder, object = nil?, folder =  nil?)
	def confirm_folder_exists(folder, object)
		return object if check_local_directory_exists("#{folder}", object)
		check_remote_exists(object[:m], object[:f]) ? clone_master(folder, object) : notify(folder, object)
	end
	#  def hidden_confirm_folder_exists				##has not been tested. make sure it works if you ever want to switch
	# 	if Repo_Finder.check_remote_exists(object[:m], object[:f]) clone()
	# 	elsif Repo_Finder.check_local_directory_exists("#{environmentFolder}", object) 
	# 	else notify
	# end 

	def clone_master(environmentFolder, object)
		Dir.chdir("../#{environmentFolder}") do
			`rm -rf #{object[:f]}`
			`git clone https://github.com/#{object[:m][:user]}/#{object[:f]}`
		end #submodulized file works if user cloned wrong and put in my repository.
		    #therefore full file system did notY
		object
	end
	def notify(folder, object)
		puts "did not find repository #{object[:f]}"
	    object[:f] = Inputs.folderName(object[:f])
	    object = confirm_folder_exists(folder, object)
	    object
		#Repo_Finder.clone_master(folder, object)
	end
	def check_remote_exists(account, folder)
		#account = (type == "master" ? object[:m] : object[:j])
		response = `curl -i https://api.github.com/repos/#{account[:user]}/#{folder}`
		response = JSON.parse(response[response.index('{')..-1])
		remote_exists = response["message"].nil?

		if remote_exists
			puts "Folder found on Github"
		end
		remote_exists
	end
	def check_local_directory_exists(folder, object)
		directory_exists = File.directory?("../#{folder}/#{object[:f]}")
		if directory_exists
			puts "Folder found in local directory"
		end
		directory_exists
	end
end