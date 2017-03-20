require "rspec"
require 'json'
require_relative "../environment.rb"
require_relative "../repo_finder.rb"
require_relative "../inputs.rb"
#  ???????????.rb
describe "the interactions with the Github API" do
	inputs = Inputs.new
	finder = Repo_Finder.new
	environment = Environment.new
	let(:check_result) { inputs.check({user: "miketestgit02", pass: "qzfreetf59im"}, 'master') }
	let(:check_invalid_result) { inputs.check({user: "miketestgit02", pass: "qzfreetf59i"}, 'master', {user: "miketestgit02", pass: "qzfreetf59im"}) }

	let(:real_repo) { finder.check_remote_exists({user: "miketestgit02", pass: "qzfreetf59im"}, 'testing') }
	let(:fake_repo) { finder.check_remote_exists({user: "miketestgit02", pass: "qzfreetf59im"}, 'foobar') }
	it "check should confirm valid credentials" do
		expect(check_result).to eq({user: "miketestgit02", pass: "qzfreetf59im"})
	end

	
	it "check request valid credentials if credentials passed are invalid" do
		expect(check_invalid_result).to eq({user: "miketestgit02", pass: "qzfreetf59im"})
	end

	it "should confirm existance of remote repo" do
		expect(real_repo).to eq(true)
	end

	it "should confirm nonexistance of remote repo" do
		expect(fake_repo).to eq(false)
	end	

	it "should confirm repo has been created" do
		`curl -u "miketestgit02:qzfreetf59im" https://api.github.com/user/repos -d '{ "name": "rspec_test_repo" }' /dev/null`
		expect( finder.check_remote_exists({user: "miketestgit02", pass: "qzfreetf59im"}, "rspec_test_repo") ).to eq(true)
	end

	it "should confirm repo has been deleted" do
		`curl -u "miketestgit02:qzfreetf59im" https://api.github.com/user/repos -d '{ "name": "rspec_test_repo" }' /dev/null`
		environment.delete_online_repo("rspec_test_repo", {user: "miketestgit02", pass: "qzfreetf59im"})
		expect( finder.check_remote_exists({user: "miketestgit02", pass: "qzfreetf59im"}, "rspec_test_repo") ).to eq(false)
	end

end