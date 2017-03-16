require "rspec"
require 'json'
require_relative "../methods.rb"
#every test will have to create an object
describe "the interactions with local Git repositories" do
	it "should add github remote to specified folder" do
		#environment.rb
		Dir.chdir("Testing") do
			establish_Origin_repo('1_test_CheckReadmeAndSubdirs', {user: "miketestgit02", pass: "qzfreetf59im"})
		end

		Dir.chdir("Testing/1_test_CheckReadmeAndSubdirs") do
			expect(`git remote --v`).to include("https://miketestgit02:qzfreetf59im@github.com/miketestgit02/1_test_CheckReadmeAndSubdirs.git")
		end
	end

	it "should replace a folder with a submodule link" do
		#environment.rb
		Dir.chdir("Testing") do
			`mkdir rspec_submodule_example`
			Dir.chdir('rspec_submodule_example') do
				`mkdir rspec_submodule_folder`
				Dir.chdir('rspec_submodule_folder') do
					`touch test.txt`


					`git init`
					`git add *`
					`git commit -m "Initial"`
					`curl -u "miketestgit02:qzfreetf59im" https://api.github.com/user/repos -d '{ "name": "rspec_submodule_folder" }' /dev/null`
					`git remote add origin https://miketestgit02:qzfreetf59im@github.com/miketestgit02/rspec_submodule_folder.git`
					`git push origin master`
				end

				`git init`
				removeFiles_addSubmodule('rspec_submodule_folder', {user: "miketestgit02", pass: "qzfreetf59im"})

				expect(File.exist?('.gitmodules')).to eq(true)

				`curl -u miketestgit02:qzfreetf59im -X DELETE  https://api.github.com/repos/miketestgit02/rspec_submodule_folder`
			end
			`rm -rf rspec_submodule_example`
		end

	end

	it "should create a commit and push it to github" do
		#environment.rb
		Dir.chdir("Testing") do
			`mkdir rspec_submodule_example`
			Dir.chdir('rspec_submodule_example') do
				`git init`
				`curl -u "miketestgit02:qzfreetf59im" https://api.github.com/user/repos -d '{ "name": "rspec_submodule_example" }' /dev/null`
				`git remote add origin https://miketestgit02:qzfreetf59im@github.com/miketestgit02/rspec_submodule_example.git`
				`touch test.txt`
				commit_andPush('rspec_submodule_folder')
				commits = `curl -i https://api.github.com/repos/miketestgit02/rspec_submodule_example/commits`
				expect(JSON.parse(commits[commits.index('[')..-1]).last["sha"]).to eq(`git rev-parse HEAD`.gsub("\n", ""))

				`curl -u miketestgit02:qzfreetf59im -X DELETE  https://api.github.com/repos/miketestgit02/rspec_submodule_example`
			end
			`rm -rf rspec_submodule_example`
		end
	end
end
