require "yaml"

module Cp8Cli
  class ConfigStore
    def initialize(path)
      @path = path
    end

    def [](key)
      data[key]
    end

    def exist?
      File.exist?(path)
    end

    def move_to(new_path)
      File.rename(path, new_path)
      @path = new_path
    end

    def save(key, value)
      data[key] = value
      File.new(path, "w") unless exist?
      File.open(path, "w") { |f| f.write(data.to_yaml) }
      value
    end

    private

      attr_reader :path

      def data
        @_data ||= load_data
      end

      def load_data
        YAML.load File.read(path)
      rescue
        {}
      end
  end
end
