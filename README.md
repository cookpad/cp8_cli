# trello_flow

## Installation

```bash
gem uninstall pt-flow # if used
gem install trello_flow
```

## Usage

```bash
git start # Shows backlog for current board
git start <card URL> # Assigns self to card, moves to "started", and creates branch
git start "Do this" # Creates card "Do this" and starts it
git open # Open relevant card/board in browser
git finish # Opens PR
git cleanup # cleans up merged card branches
```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
