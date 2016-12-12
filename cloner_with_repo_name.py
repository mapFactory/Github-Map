import os
import git
import requests

from git import Repo
username = raw_input("Please enter your Github account name: ")
repo_name = raw_input("Please enter the name of the repository: ")

repository = requests.get("https://api.github.com/repos/" + username + "/" + repo_name).json()

if repository.get("name"):
	command = git.Git().clone("https://github.com/" + username + "/" + repo_name + ".git",
		"my_repositories/" + repo_name, recursive=True)
	r = Repo("my_repositories/" + repo_name)
	r.create_remote('originate', "https://github.com/" + username + "/" + repo_name + ".git")
	print command
else:
	print "This repository does not exist"
