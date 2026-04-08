# frozen_string_literal: true

require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/path_configuration"
require 'yaml'

module PathBrancher
  ##
  # A basic PathConfiguration implementation that loads configuration from a YAML file. The YAML file should define the
  # forks and their corresponding turn_left_flag or turn_left_percentage values.
  class FilePathConfiguration
    include PathBrancher::PathConfiguration

    ##
    # Initializes the FilePathConfiguration with the given YAML file path, an optional path cache, and an optional
    # random generator.
    #
    # @param file_path [String] The path to the YAML configuration file.
    # @param path_cache [PathResultCache] (optional) An optional result cache to store percentage-based decisions,
    #   providing consistency across calls with the same fork_name and metadata.
    # @param random_generator [Random] (optional) An optional random number generator, for use with percentage-based
    #   decisions.
    def initialize(file_path, path_cache = nil, random_generator = Random.new)
      @configuration_data = load_configuration(file_path)
      @path_cache = path_cache
      @random_generator = random_generator
    end

    def turn_left?(fork_name, metadata)
      return unless @configuration_data.key?(fork_name)

      if @configuration_data[fork_name].key?('turn_left_flag')
        @configuration_data[fork_name]['turn_left_flag']
      elsif @configuration_data[fork_name].key?('turn_left_percentage')
        if @configuration_data[fork_name]['turn_left_percent_cache']
          if @path_cache.cached?(fork_name, metadata)
            @path_cache.get(fork_name, metadata)
          else
            result = @configuration_data[fork_name]['turn_left_percentage'] >= random_percentage
            @path_cache.put(fork_name, metadata, result)
            result
          end
        else
          @configuration_data[fork_name]['turn_left_percentage'] >= random_percentage
        end
      end
    end

    private

    def load_configuration(file_path)
      YAML.load_file(file_path)
    end

    def random_percentage
      @random_generator.rand(0.0..100.0)
    end
  end
end
