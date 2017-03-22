class Inputs
  def self.folderName(folder = nil) puts "Please enter folder name: "; folder = STDIN.gets; folder = folder.gsub("\n", ""); end #called specifically in task
  def accountName(str) puts "Please enter Github account name for #{str} repository: "; username = STDIN.gets; username.gsub("\n", ""); end #inputsToUser
  def accountPassword(str) puts "Please enter password for #{str} Github account: "; password = STDIN.noecho(&:gets); password.gsub("\n", ""); end #inputsToUser

  def self.inputsToUser(folder = nil, master = nil, junk = nil)
    inputs = Inputs.new
    if folder.nil? && master.nil? && junk.nil?
      folder = Inputs.folderName()
      master = {user: inputs.accountName("master"), pass: inputs.accountPassword("master")}
      junk = {user: inputs.accountName("junk"), pass: inputs.accountPassword("junk")}
    end
    return {f: folder, j: inputs.check(junk, 'junk'), m: inputs.check(master, 'master')}
  end#parameters added would be void... hope is pass by ref.(master, junk)





  def recollect_account_credentials(account, type, new_credentials = nil)
    puts "Account credentials for #{account[:user]} (#{type} account) invalid."
    if(new_credentials.nil?)
      puts "Username: ";username = STDIN.gets
      puts "Password: ";password = STDIN.noecho(&:gets)
    else
      username = new_credentials[:user]
      password = new_credentials[:pass]
    end
    return {user: username.gsub("\n", ""), pass: password.gsub("\n", "")}
  end
  def check(credentials, type, new_credentials = nil)
    response = `curl -i https://api.github.com -u #{credentials[:user]}:#{credentials[:pass]}`
    response = JSON.parse(response[response.index('{')..-1])
    response["message"] ? check(recollect_account_credentials(credentials, type, new_credentials), type) : credentials
  end
end