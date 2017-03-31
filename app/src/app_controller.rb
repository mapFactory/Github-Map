require_relative 'github_modifier.rb'
require_relative 'prior_mapped.rb'
require_relative 'folder_setup.rb'
require_relative 'backup.rb'
require_relative 'make_readme.rb'
class AppController
# def surface_folder_level(folder, account, exist)
  def surface_folder_level(folder, account, exist, environment)
    Dir.chdir("#{folder}") do |i| #current_directory()
      if exist
        MakeReadme.touchwithReadme(folder)
        environment.create_Repo_From_subFolder(folder, account)
      else
        environment.delete_online_repo(folder, account)
      end
    end
  end
  #def sub_folder_level(folder, object, exist)
  def sub_folder_level(folder, object, exist, environment)
    Dir.foreach(folder) do |x|
      if(File.directory?("#{folder}/#{x}"))
              if !(x == ".." || x == "." || x == ".git") #sub_directories()
                      initialize_submodule("#{folder}/#{x}", object, exist, 'junk', environment)
                      if exist
                        Dir.chdir("#{folder}") do |i|
                              environment.removeFiles_addSubmodule(x, object[:j])
                              environment.commit_andPush(x)
  end end end   end   end end
  def master_has_subfolders_or_is_subfolder_already(folder, type)#subfolder would mean that type is "junk"
    if type == "master"
      puts "master"
      has_subfolders = false
      Dir.foreach(folder) do |x|
        if(File.directory?("#{folder}/#{x}"))
          if !(x == ".." || x == "." || x == ".git")
            has_subfolders = true
          end
        end
      end
      return has_subfolders
    else
      return true
    end
    #if the return has not happened by now it is presumably false.
  end
  def confirm_expected_subfolders_exist(folder, environmentFolder)
    backup_folder_count = folder_counter("../#{environmentFolder}/backup_#{folder}")
    current_folder_count = folder_counter("../#{environmentFolder}/#{folder}")
    current_folder_count == backup_folder_count
  end
  def folder_counter(folder)
    count = 0
    Dir.foreach(folder) do |x|
      if !(x == ".." || x == "." || x == ".git") && File.directory?("#{folder}/#{x}")
        count += 1
        Dir.chdir("#{folder}") do |i|
          count += folder_counter("#{x}")
        end
      end
    end
    count
  end
  def initialize_submodule(folder, object, exist, type, environment)
    # if exist && type == "master"
    #   clone_master(folder.split('/').first, object)
    #   Backup(folder.split('/').first, object[:f])
    #   set_submodulized(folder.split('/').first, folder.split('/')[-1]) 
    # end
    # if !exist && type == "master"
    #   unset_submodulized(folder.split('/').first, folder.split('/')[-1]) 
    # end
    if master_has_subfolders_or_is_subfolder_already(folder, type)
      account = (type == "master" ? object[:m] : object[:j])
      # check_repo_exist(account)if_object[j]
      surface_folder_level(folder, account, exist, environment)
      sub_folder_level(folder, object, exist, environment)

      puts exist ? "#{folder} added to map" : "#{folder} removed from map"
    else puts "No subfolders found in this repository. No actions were taken."
  end end# folder is full path to folder e.g.(github_repo_submodulizer/my_repositories/test/folder)
  
  def self.automate(environmentFolder, object, exist, type)
    #Below logic needs to be refactored
    github_modifier = GithubModifier.new
    controller = AppController.new
    mapped = Prior_Mapped.new
    setup = Folder_Setup.new

    object = setup.confirm_folder_exists(environmentFolder, object)
    if exist
      Backups.Backup(environmentFolder, object[:f])
    end
    controller.initialize_submodule("../#{environmentFolder}/#{object[:f]}", object, exist, type, github_modifier)

    if exist
      if controller.confirm_expected_subfolders_exist(object[:f], environmentFolder)
        puts "Folder added to Github at https://github.com/#{object[:m][:user]}/#{object[:f]}"
      else
        puts "Folder corrupt. Please run de_github_map and revert to your backup"
      end
    else
      puts "Folder removed from Github"
    end
  end
end