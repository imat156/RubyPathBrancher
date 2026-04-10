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

    ##
    # Determines whether to turn left for the given fork name and metadata, based on the configuration loaded from the
    # YAML file. If the fork name is not defined in the configuration, an ArgumentError is raised.
    #
    # @param fork_name [String] The name of the fork to evaluate.
    # @param metadata [Hash] A hash of metadata that may be used for percentage-based decisions.
    #
    # @return [Boolean] true if the path should turn left, false otherwise.
    # @raise [ArgumentError] If the fork name is not defined in the configuration.
    def turn_left?(fork_name, metadata)
      unless @configuration_data.key?(fork_name)
        raise ArgumentError, "Fork name '#{fork_name}' is not defined in this configuration"
      end

      if @configuration_data[fork_name].key?('turn_left_flag')
        turn_left_flag?(fork_name)
      elsif @configuration_data[fork_name].key?('turn_left_percentage')
        turn_left_based_on_percentage?(fork_name, metadata)
      end
    end

    private

    ##
    # Loads the configuration from the specified YAML file path.
    #
    # @param file_path [String] The path to the YAML configuration file.
    #
    # @return [Hash] The configuration data loaded from the YAML file.
    def load_configuration(file_path)
      YAML.load_file(file_path)
    end

    ##
    # Determines whether to turn left based on the turn_left_flag value for the given fork name.
    #
    # @param fork_name [String] The name of the fork to evaluate.
    #
    # @return [Boolean] The value of turn_left_flag for the given fork name.
    def turn_left_flag?(fork_name)
      @configuration_data[fork_name]['turn_left_flag']
    end

    ##
    # Determines whether to turn left based on the turn_left_percentage value for the given fork name.
    # Caches the result if turn_left_percent_cache is true for the fork, ensuring consistent decisions for the same
    # fork_name and metadata.
    #
    # @param fork_name [String] The name of the fork to evaluate.
    # @param metadata [Hash] A hash of metadata that may be used for percentage-based decisions.
    #
    # @return [Boolean] true if the path should turn left, false otherwise.
    def turn_left_based_on_percentage?(fork_name, metadata)
      if @configuration_data[fork_name]['turn_left_percent_cache']
        turn_left_percent_cache?(fork_name, metadata)
      else
        turn_left_percentage_great_enough?(fork_name)
      end
    end

    ##
    # Determines whether to turn left based on the turn_left_percentage value for the given fork name, using caching to
    # ensure consistent decisions for the same fork_name and metadata.
    #
    # @param fork_name [String] The name of the fork to evaluate.
    # @param metadata [Hash] A hash of metadata that may be used for percentage-based decisions.
    #
    # @return [Boolean] true if the path should turn left, false otherwise.
    def turn_left_percent_cache?(fork_name, metadata)
      if @path_cache.cached?(fork_name, metadata)
        @path_cache.get(fork_name, metadata)
      else
        result = turn_left_percentage_great_enough?(fork_name)
        @path_cache.put(fork_name, metadata, result)
        result
      end
    end

    ##
    # Determines whether the turn left percentage exceeds a randomly generated percentage.
    #
    # @param fork_name [String] The name of the fork to evaluate.
    #
    # @return [Boolean] true if the turn left percentage is great enough, false otherwise.
    def turn_left_percentage_great_enough?(fork_name)
      @configuration_data[fork_name]['turn_left_percentage'] >= random_percentage
    end

    ##
    # Generates a random percentage between 0.0 and 100.0 using the provided random generator.
    #
    # @return [Float] A random percentage between 0.0 and 100.0.
    def random_percentage
      @random_generator.rand(0.0..100.0)
    end
  end
end
