
module Pod
  class GitMap
    @@gitMap = {}
    @@hasGitMap = true
    GitMapFile = '.GitMap.yml'
    @@repo = nil

    def self.set_repo(repo)
      @@repo = repo
    end

    def self.get_git_url(name)
      mapping = self.mapping
      name = name.include?('/') ? name.split('/').first : name
      return mapping && @@repo ? mapping[@@repo][name] : nil
    end

    def self.mapping
      return @@gitMap unless @@gitMap.empty?
      return unless @@hasGitMap

      root = Config.instance.installation_root
      gitmap_file = root.join GitMapFile
      if gitmap_file.exist?
        @@gitMap = YAML.load(File.read(gitmap_file))
      else
        @@hasGitlabConfig = false
        UI.message "不存在#{GitMapFile}文件"
      end
      @@gitMap
    end
    private_class_method :mapping
  end
end