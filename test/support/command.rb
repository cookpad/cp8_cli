require "active_support/core_ext/hash"

def stub_shell
  Cp8Cli::Command.client = Minitest::Mock.new
end

def shell
  Cp8Cli::Command.client
end

def stub_github_user(name)
  shell.expect :read, name, ["git config user.name"]
end

def stub_repo(repo)
  shell.expect :read, repo, ["git config --get remote.origin.url"]
end

def stub_branch(branch)
  shell.expect :read, branch, ["git rev-parse --abbrev-ref HEAD"]
end

def expect_checkout(branch)
  shell.expect :run, nil, ["git checkout #{branch} >/dev/null 2>&1 || git checkout -b #{branch}"]
end

def expect_commit(message)
  expected_command = "git commit --allow-empty -m\"#{message}\""
  shell.expect :run, nil, [expected_command]
end

def expect_push(branch)
  shell.expect :run, nil, ["git push origin #{branch} -u"]
end

def expect_error(error)
  shell.expect :error, nil, [error]
end

def expect_pr(repo:, from:, to:, **options)
  expected_from = CGI.escape(from)
  query = options.to_query

  expect_open_url("https://github.com/#{repo}/compare/#{to}...#{expected_from}?#{query}")
end

def expect_question(question, answer = nil)
  shell.expect :ask, answer, [question]
end

def expect_reset(branch)
  shell.expect :read, false, ["git status --porcelain"]
  shell.expect :run, nil, ["git reset --hard origin/#{branch}"]
end

def expect_open_url(url)
  shell.expect :open_url, true, [url]
end
