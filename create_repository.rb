require 'octokit'

puts "Please enter your Github account name: "
STDOUT.flush
account_name = gets.chomp
puts "Please enter your Github password: "
STDOUT.flush
password = gets.chomp
puts "Please enter the repository name: "
STDOUT.flush
repo_name = gets.chomp

Octokit.configure do |c|
  c.login = account_name
  c.password = password
end

Octokit.create_repository(repo_name)

