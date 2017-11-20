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

def expect_push(branch)
  shell.expect :run, nil, ["git push origin #{branch} -u"]
end

def expect_error(error)
  shell.expect :error, nil, [error]
end

def expect_pr(repo:, from:, to:, title:, body:)
  expected_from = CGI.escape(from)
  expected_title = CGI.escape(title)
  expected_body = CGI.escape(body)

  expect_open_url("https://github.com/#{repo}/compare/#{to}...#{expected_from}?title=#{expected_title}&body=#{expected_body}&expand=1")
end

def expect_open_url(url)
  shell.expect :open_url, true, [url]
end
