require 'io/console'
require 'json'
require_relative 'src/inputs.rb'
require_relative 'src/backup.rb'
require_relative 'src/app_controller.rb'
require_relative 'src/update.rb'

#production Tasks
task :update_submodule_folder_history do
	object = inputsToUser()
	update_repository("my_repositories", object, type = 'master')
end
task :github_map do #works
	object = Inputs.inputsToUser()
	AppController.automate("my_repositories", object, exist = true, type = 'master')
end
task :de_github_map do
	object = Inputs.inputsToUser()
	AppController.automate("my_repositories", object, exist = false, type= 'master')
end