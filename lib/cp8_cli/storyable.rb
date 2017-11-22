module Cp8Cli
  module Storyable
    def branch
      @_branch ||= Branch.from_story(self)
    end
  end
end
