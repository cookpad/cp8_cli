def stub_trello(method, path)
  stub_request(method, "https://api.trello.com:443/1#{path}").with(query: { key: "PUBLIC_KEY", token: "MEMBER_TOKEN"})
end
