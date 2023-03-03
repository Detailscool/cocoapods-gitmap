require 'cocoapods-gitmap/helper/git_map'

module Pod
  class Podfile
    module DSL
      alias old_pod pod
      def pod(name = nil, *requirements)
        if plugins.keys.include?('cocoapods-gitmap')
          requirements = requirements.map do |requirement|
            GitMap.config_options(name, requirement, self)
          end
        end
        old_pod(name, *requirements)
      end

      def set_repo(repo)
        GitMap.set_repo(repo)
      end
    end
  end
end