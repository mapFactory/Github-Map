class Backups
	def self.submodule_backup(environmentFolder, folder)
		Dir.chdir("#{environmentFolder}/") do |x|
	    	if File.directory?("submodulebackup_#{folder}")
	    		puts `rm -rf submodulebackup_#{folder}`
	    	end
	    	puts `cp -r #{folder} submodulebackup_#{folder}` 
	    end
	end
	def self.Backup(environmentFolder, folder)
	    Dir.chdir("#{environmentFolder}/") do |x|
	    	if !File.directory?("backup_#{folder}")
	    		puts `cp -r #{folder} backup_#{folder}` 
	    	end
	    end
	end# Copy never to be touched till end... if copy already exists it should be ignored or copy itself not be overridden
	def self.Delete_Backup(environmentFolder, folder)
	    Dir.chdir("#{environmentFolder}/") do |x|
	        puts `rm -rf backup_#{folder}` 
	    end
	end
end