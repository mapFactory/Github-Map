	def touchwithReadme(folder)
		if Dir["#{folder}/*"].empty?
			puts `touch README.md`
		end
	end