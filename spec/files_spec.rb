require "rspec"
require_relative "../submodule_cop.rb"
require_relative "../backup.rb"
describe "the interactions with files" do
	it "should create a backup of specified submodule folders" do
		#submodule_cop.rb
		Backups.submodule_backup("Testing", "1_test_CheckReadmeAndSubdirs")
		Dir.chdir("Testing") do
			expect(File.directory?('submodulebackup_1_test_CheckReadmeAndSubdirs')).to eq(true)
		end
	end

	it "should create a backup of specified folders" do
		#backup.rb
		Backups.Backup("Testing", "1_test_CheckReadmeAndSubdirs")
		Dir.chdir("Testing") do
			expect(File.directory?('backup_1_test_CheckReadmeAndSubdirs')).to eq(true)
		end
	end

	it "should delete backup of specified folders" do
		#backup.rb
		Backups.Backup("Testing", "1_test_CheckReadmeAndSubdirs")
		Backups.Delete_Backup("Testing", "1_test_CheckReadmeAndSubdirs")
		Dir.chdir("Testing") do
			expect(File.directory?('backup_1_test_CheckReadmeAndSubdirs')).to eq(false)
		end
	end
end