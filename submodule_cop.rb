
#ensures repo is not submodulized twice and assures that the Github Map submodulized it
def set_touch_submodulized(environmentFolder, folder)
		Dir.chdir("#{environmentFolder}/#{folder}") do |x|
			puts "file touched"
			`touch .submodulized`
		end
	end
	def unset_remove_submodulized(environmentFolder, folder)
		Dir.chdir("#{environmentFolder}/#{folder}") do |x|
			`rm .submodulized`
		end
	end
	def check_submodulized(environmentFolder, folder)
		Dir.chdir("#{environmentFolder}/#{folder}") do |x|
			return File.exist?('.submodulized')
		end
	end
end