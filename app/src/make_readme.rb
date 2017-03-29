class MakeReadme
  def self.touchwithReadme(folder)
    if Dir["#{folder}/*"].empty?
      `touch README.md`
    end
  end
end