require "rspec"
require_relative "../app/src/backup.rb"
describe "the interactions with files" do
	it "should create a backup of specified submodule folders" do
		#submodule_cop.rb
		Dir.chdir("spec/Testing") do
			Backups.submodule_backup("Testing", "1_test_CheckReadmeAndSubdirs")
			expect(File.directory?('submodulebackup_1_test_CheckReadmeAndSubdirs')).to eq(true)
		end
	end

	it "should create a backup of specified folders" do
		#backup.rb
		Dir.chdir("spec/Testing") do
			Backups.Backup("Testing", "1_test_CheckReadmeAndSubdirs")
			expect(File.directory?('backup_1_test_CheckReadmeAndSubdirs')).to eq(true)
		end
	end

	it "should delete backup of specified folders" do
		#backup.rb
		Dir.chdir("spec/Testing") do
			Backups.Backup("Testing", "1_test_CheckReadmeAndSubdirs")
			Backups.Delete_Backup("Testing", "1_test_CheckReadmeAndSubdirs")
			expect(File.directory?('backup_1_test_CheckReadmeAndSubdirs')).to eq(false)
		end
	end
end