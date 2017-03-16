class NotEmptyCop
	def self.touchwithReadme(folder)
		if Dir["#{folder}/*"].empty?
			puts `touch README.md`
		end
	end
end