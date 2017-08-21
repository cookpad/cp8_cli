def stub_cli
  TrelloFlow::Cli.client = Minitest::Mock.new
end

def cli
  TrelloFlow::Cli.client
end

def stub_repo(repo)
  cli.expect :read, repo, ["git config --get remote.origin.url"]
end

def stub_branch(branch)
  cli.expect :read, branch, ["git rev-parse --abbrev-ref HEAD"]
end

def expect_checkout(branch)
  cli.expect :run, nil, ["git checkout #{branch} >/dev/null 2>&1 || git checkout -b #{branch}"]
end

def expect_push(branch)
  cli.expect :run, nil, ["git push origin #{branch} -u"]
end

def expect_error(error)
  cli.expect :error, nil, [error]
end

def expect_pr(repo:, from:, to:, title:, body:)
  expected_from = URI.escape(from)
  expected_title = URI.escape(title)
  expected_body = URI.escape(body)

  expect_open_url("https://github.com/#{repo}/compare/#{to}...#{expected_from}?expand=1&title=#{expected_title}&body=#{expected_body}")
end

def expect_open_url(url)
  cli.expect :open_url, true, [url]
end
