module Cp8Cli
  class ConfigStore
    def initialize(path)
      @path = path
    end

    def [](key)
      data[key]
    end

    def save(key, value)
      data[key] = value
      File.new(path, "w") unless File.exists?(path)
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
