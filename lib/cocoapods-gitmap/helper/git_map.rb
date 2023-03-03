
module Pod
  class GitMap
    @@gitMap = {}
    @@hasGitMap = true
    GitMapFile = '.GitMap.yml'
    @@repo = nil
    @@default_branch = nil

    def self.set_repo(repo, default_branch)
      @@repo = repo
      @@default_branch = default_branch
    end

    def self.get_git_url(name)
      mapping = self.mapping
      name = name.include?('/') ? name.split('/').first : name
      return mapping && @@repo ? mapping[@@repo][name] : nil
    end

    def self.get_git_commit_from_default_branch(git_url)
      return unless @@default_branch
      command = ['ls-remote',
                 '--',
                 git_url,
                 @@default_branch]
      output = Downloader::Git.execute_command('git', command)

      encoded_branch_name = @@default_branch.dup.force_encoding(Encoding::ASCII_8BIT)
      match = %r{([a-z0-9]*)\trefs\/(heads|tags)\/#{Regexp.quote(encoded_branch_name)}}.match(output)
      match[1] unless match.nil?
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