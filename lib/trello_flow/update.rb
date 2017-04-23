module TrelloFlow
  class Update
    def initialize(branch)
      @feature_branch = branch
      @master_branch = Branch.new("master")
    end

    def run
      master_branch.checkout
      master_branch.pull
      feature_branch.checkout
      feature_branch.rebase
    end

    private
      attr_reader :feature_branch, :master_branch
  end
end
