# trello_flow

## Installation

```bash
gem uninstall pt-flow # if used
gem install trello_flow
```

## Usage

```bash
git open # Open relevant card/all user's cards in browser
git start # Pick a board to see backlog
git start <card URL> # Assigns self to card, moves to "started", and creates branch
git start "Do this" # Picking a board creates card "Do this" and starts it
git finish # Opens PR
git cleanup # cleans up merged card branches
```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
