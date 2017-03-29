require_relative 'environment.rb'
require_relative 'submodule_cop.rb'
require_relative 'repo_finder.rb'
require_relative 'backup.rb'
require_relative 'not_empty_cop.rb'
class Navigator
# def surface_folder_level(folder, account, exist)
  def surface_folder_level(folder, account, exist, environment)
    Dir.chdir("#{folder}") do |i| #current_directory()
      if exist
        NotEmptyCop.touchwithReadme(folder)
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
            end
         end
        end
      end
    end
  end

  def master_has_subfolders_or_is_subfolder_already(folder, type)#subfolder would mean that type is "junk"
    if type == "master"
      Dir.foreach(folder) do |x|
        if(File.directory?("../#{folder}/#{x}"))
          if !(x == ".." || x == "." || x == ".git") #sub_directories()
            return 2
          end
        end
      end
    else
      return true
    end
    #if the return has not happened by now it is presumably false.
  end

  def initialize_submodule(folder, object, exist, type, environment)
    if master_has_subfolders_or_is_subfolder_already(folder, type)
      account = (type == "master" ? object[:m] : object[:j])
      # check_repo_exist(account)if_object[j]
      surface_folder_level(folder, account, exist, environment)
      sub_folder_level(folder, object, exist, environment)
    else puts "No subfolders found in this repository. No actions were taken."
  end end# folder is full path to folder e.g.(github_repo_submodulizer/my_repositories/test/folder)

  def self.automate(environmentFolder, object, exist, type)
    environment = Environment.new;navigator = Navigator.new;cop = SubmoduleCop.new;finder = Repo_Finder.new

    object = finder.confirm_folder_exists(environmentFolder, object)
    if (exist && !cop.check_submodulized(environmentFolder, object[:f])) || (!exist && cop.check_submodulized(environmentFolder, object[:f]))
      if exist
        #Repo_Finder.clone_master(environmentFolder, object)
        Backups.Backup(environmentFolder, object[:f])
        cop.set_touch_submodulized(environmentFolder, object[:f])
      else
        cop.unset_remove_submodulized(environmentFolder, object[:f])
      end

      navigator.initialize_submodule("../#{environmentFolder}/#{object[:f]}", object, exist, type, environment)
      Backups.submodule_backup(environmentFolder, object[:f])
    else
      puts "Folder is already submodulized. No actions taken."
    end
  end
end
