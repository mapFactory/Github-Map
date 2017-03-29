require_relative 'folder_setup.rb'
require_relative 'backup.rb'
class GithubModifier 
  def create_Repo_From_subFolder(folder, account)
      start_repo_locally()
      create_online_repo(folder, account)
      if check_online_repo(folder.split('/')[-1], account)
        establish_Origin_repo(folder, account)
        `git push origin master --quiet`
      else
        puts "Failed to create remote repo for #{folder}."
      end
      #check_remote_exist() *check remote exists here* warning: adds additional ping
      #puts folder
      
  end# creates empty repo using name of given folder as repo name.# folder name is collected by spliting "folder" and string after last "/"
  
  #local folder stucture
  def start_repo_locally
    `git init`;`git add *`;`git commit -m "Initial Commit"`;
  end
  def establish_Origin_repo(folder, account)
      `git remote rm origin`
      `git remote add origin https://#{account[:user]}:#{account[:pass]}@github.com/#{account[:user]}/#{folder.split('/')[-1]}.git`
  end #do not puts anything that shows credentials  
  def commit_andPush(x)
    `git rm --cached -rf #{x}`
    `git add *`;`git commit -m "Add submodule folder #{x}"`;`git push origin master --quiet`
  end
  def removeFiles_addSubmodule(x, junk)
    `git rm --cached -rf #{x}`
    `git submodule add https://github.com/#{junk[:user]}/#{x}`
  end

  #github interaction
  def delete_online_repo(folder, account) # When we have the program running, we will update this.
    username = account[:user];password = account[:pass];
    `curl -u #{username}:#{password} -X DELETE  https://api.github.com/repos/{#{username}}/{#{folder.split('/')[-1]}}`;#puts folder.split('/')[-1];
  end
  def create_online_repo(folder, account)
    `curl -u "#{account[:user]}:#{account[:pass]}" https://api.github.com/user/repos -d '{ "name": "#{folder.split('/')[-1]}" }' /dev/null`
  end
  def check_online_repo(folder, account)
    response = `curl -i https://api.github.com/repos/#{account[:user]}/#{folder}`
    response = JSON.parse(response[response.index('{')..-1])
    response["message"].nil?
  end 

end