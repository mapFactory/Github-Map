require "rspec"
require 'json'
require_relative "../methods.rb"
describe "the interactions with the Github API" do
	let(:check_result) { check({user: "miketestgit02", pass: "qzfreetf59im"}, 'master') }
	let(:check_invalid_result) { check({user: "miketestgit02", pass: "qzfreetf59i"}, 'master') }

	let(:real_repo) { check_remote_exists({user: "miketestgit02", pass: "qzfreetf59im"}, 'testing') }
	let(:fake_repo) { check_remote_exists({user: "miketestgit02", pass: "qzfreetf59im"}, 'foobar') }
	it "check should confirm valid credentials" do
		expect(check_result).to eq({user: "miketestgit02", pass: "qzfreetf59im"})
	end

	#fix later
	# it "check request valid credentials if credentials passed are invalid" do
	# 	expect(check_invalid_result).to eq({user: "miketestgit02", pass: "qzfreetf59im"})
	# end

	it "should confirm existance of remote repo" do
		expect(real_repo).to eq(true)
	end

	it "should confirm nonexistance of remote repo" do
		expect(fake_repo).to eq(false)
	end	

	#fix later
	# it "should confirm repo has been created" do

	# end

	it "should confirm repo has been deleted" do
		`curl -u "miketestgit02:qzfreetf59im" https://api.github.com/user/repos -d '{ "name": "rspec_test_repo" }' /dev/null`
		delete_online_repo("rspec_test_repo", {user: "miketestgit02", pass: "qzfreetf59im"})
		expect( check_remote_exists({user: "miketestgit02", pass: "qzfreetf59im"}, "rspec_test_repo") ).to eq(false)
	end

end