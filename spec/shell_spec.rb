require "rspec"
require 'json'
require_relative '../app/src/inputs.rb'
require_relative '../app/src/app_controller.rb'
describe "rake commands" do 

	it "test map should put repo on Github" do
		Dir.chdir("app") do 
			object = Inputs.inputsToUser("4_test_RecursiveClone" ,master = {user: "miketestgit02", pass: "qzfreetf59im"},junk = {user: "miketestgit02", pass: "qzfreetf59im"})
			AppController.automate("Testing",object, exist = true, type= 'junk', false)
			finder = Folder_Setup.new
			real_repo = finder.check_remote_exists({user: "miketestgit02", pass: "qzfreetf59im"}, '4_test_RecursiveClone')
			expect(real_repo).to eq(true)
		end
	end

	it "test map should put repo on Github" do
		Dir.chdir("app") do 
			object = Inputs.inputsToUser("4_test_RecursiveClone" ,master = {user: "miketestgit02", pass: "qzfreetf59im"},junk = {user: "miketestgit02", pass: "qzfreetf59im"})
			AppController.automate("Testing",object, exist = false, type= 'junk', false)
			finder = Folder_Setup.new
			real_repo = finder.check_remote_exists({user: "miketestgit02", pass: "qzfreetf59im"}, '4_test_RecursiveClone')
			expect(real_repo).to eq(false)
		end
	end
	
end