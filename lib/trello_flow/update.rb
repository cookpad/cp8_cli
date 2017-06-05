module TrelloFlow
  class Update
    def initialize(branch)
      @feature_branch = branch
      @target_branch = Branch.new(branch.target)
    end

    def run
      target_branch.checkout
      target_branch.pull
      feature_branch.checkout
      feature_branch.rebase
    end

    private
      attr_reader :feature_branch, :target_branch
  end
end
