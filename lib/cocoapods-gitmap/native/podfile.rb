require 'cocoapods-gitmap/helper/git_map'

module Pod
  class Podfile
    module DSL
      alias old_pod pod
      def pod(name = nil, *requirements)
        if plugins.keys.include?('cocoapods-gitmap')
          requirements.each do |requirement|
            git_url = requirement[:git]
            if git_url
              new_git_url = GitMap.get_git_url(name)
              requirement[:git] = new_git_url || git_url

              commit = requirement[:commit]
              if new_git_url && commit
                requirement[:commit] = GitMap.get_git_commit_from_default_branch(new_git_url) || commit
              end
            end
          end
        end
        old_pod(name, *requirements)
      end

      def set_repo(repo, default_branch=nil)
        GitMap.set_repo(repo, default_branch=default_branch)
      end
    end
  end
end