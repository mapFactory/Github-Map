require_relative 'inputs.rb'
class Repo_Finder

	def confirm_folder_exists(folder, object)
		return object if check_local_directory_exists("#{folder}", object)
		check_remote_exists(object[:m], object[:f]) ? clone_master(folder, object) : notify(folder, object)
	end
	def clone_master(environmentFolder, object)
		Dir.chdir("../#{environmentFolder}") do
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
	end
	def check_remote_exists(account, folder)
		response = `curl -i https://api.github.com/repos/#{account[:user]}/#{folder}`
		response = JSON.parse(response[response.index('{')..-1])
		response["message"].nil?
	end
	def check_local_directory_exists(folder, object)
		File.directory?("../#{folder}/#{object[:f]}")
	end
end
