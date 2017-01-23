require "rspec"
require_relative "../methods.rb"
describe "the interactions with files" do
	it "should create a backup of specified submodule folders" do
		submodule_backup("Testing", "1_test_CheckReadmeAndSubdirs")
		Dir.chdir("Testing") do
			expect(File.directory?('submodulebackup_1_test_CheckReadmeAndSubdirs')).to eq(true)
		end
		
	end

	it "should create a backup of specified folders" do
		Backup("Testing", "1_test_CheckReadmeAndSubdirs")
		Dir.chdir("Testing") do
			expect(File.directory?('backup_1_test_CheckReadmeAndSubdirs')).to eq(true)
		end
	end

	it "should delete backup of specified folders" do
		Backup("Testing", "1_test_CheckReadmeAndSubdirs")
		Delete_Backup("Testing", "1_test_CheckReadmeAndSubdirs")
		Dir.chdir("Testing") do
			expect(File.directory?('backup_1_test_CheckReadmeAndSubdirs')).to eq(false)
		end
	end
end