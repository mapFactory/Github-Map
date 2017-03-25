def update_repository(environmentFolder, object, type)
	`git clone --recursive https://github.com/MichaelDimmitt/#{object[:f]}.git`
	`cd #{object[:f]}/;git submodule update --remote --merge;`
	`git add .;git commit -m "applied update operation git submodule update --remote --merge”;git push;`
	`git clone --recursive https://github.com/MichaelDimmitt/#{object[:f]}.git;`
end
