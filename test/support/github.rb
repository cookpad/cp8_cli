def stub_github(method, path)
  stub_request(method, "https://api.github.com:443#{path}")
end
