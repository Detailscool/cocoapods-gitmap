
module Pod
  class GitMap
    @@gitMap = {}
    @@hasGitMap = true
    GitMapFile = '.GitMap.yml'
    @@repo = nil

    def self.set_repo(repo)
      @@repo = repo
    end

    def self.repo_cofig(name)
      mapping = self.mapping
      name = name.include?('/') ? name.split('/').first : name
      return mapping && @@repo ? mapping[@@repo][name] : nil
    end

    def self.config_options(name, requirement)
      repo_cofig = self.repo_cofig name
      return unless repo_cofig

      git_url = repo_cofig[:git]
      requirement[:git] = git_url if git_url

      commit = repo_cofig[:commit]
      if commit
        requirement[:commit] = commit
        return
      end

      branch = repo_cofig[:branch]
      return unless branch

      command = ['ls-remote',
                 '--',
                 git_url,
                 branch]
      output = Downloader::Git.execute_command('git', command)

      encoded_branch_name = branch.dup.force_encoding(Encoding::ASCII_8BIT)
      match = %r{([a-z0-9]*)\trefs\/(heads|tags)\/#{Regexp.quote(encoded_branch_name)}}.match(output)
      match = match[1] unless match.nil?
      requirement[:commit] = match if match
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