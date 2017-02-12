require_relative 'inputs.rb'
class Repo_Finder
	
#discuss another day... this is currently not returning object rather true false.	
# -- def self.confirm_folder_exists(folder, object = nil?, folder =  nil?)
	def confirm_folder_exists(folder, object)
		return if check_local_directory_exists("#{environmentFolder}", object)
		#Repo_Finder.check_remote_exists(object[:m], object[:f]) ? clone_master(environmentFolder, object) : notify
		if check_remote_exists(object[:m], object[:f]) ? clone_master(environmentFolder, object) : notify(environmentFolder, object)
	end
	#  def hidden_confirm_folder_exists				##has not been tested. make sure it works if you ever want to switch
	# 	if Repo_Finder.check_remote_exists(object[:m], object[:f]) clone()
	# 	elsif Repo_Finder.check_local_directory_exists("#{environmentFolder}", object) 
	# 	else notify
	# end 
	private 

	def clone_master(environmentFolder, object)
		Dir.chdir("#{environmentFolder}") do
			puts `rm -rf #{object[:f]}`
			puts `git clone https://github.com/#{object[:m][:user]}/#{object[:f]}`
		end 
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
		response["message"].nil?
	end
	def check_local_directory_exists(folder, object)
		File.directory?("#{folder}/#{object[:f]}")
	end
end