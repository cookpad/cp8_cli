module Cp8Cli
  class Story
    def self.find_by_short_link(short_link)
      if short_link.include?("#")
        Github::Issue.find_by_short_link(short_link)
      else
        AdhocStory.find_by_short_link(short_link)
      end
    end

    def branch
      @_branch ||= Branch.from_story(self)
    end
  end
end
