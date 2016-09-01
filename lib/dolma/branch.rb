require "active_support/core_ext/string/inflections"

module Dolma
  class Branch

    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def self.current
      new(`git rev-parse --abbrev-ref HEAD`.strip)
    end

    def self.from_item(item)
      new("#{current.target}.#{item.name_without_mentions.parameterize[0..50]}.#{item.id}")
    end

    def checkout
      Cli.run("git checkout -b #{to_s}")
    end

    def target
      name.split('.').first
    end

    def release_branch?
      target != 'master'
    end

    def task_id
      name[/\d+$/] || ''
    end

    def to_s
      name
    end
  end
end
