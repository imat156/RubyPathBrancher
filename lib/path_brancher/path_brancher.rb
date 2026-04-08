# frozen_string_literal: true

module PathBrancher
  ##
  # Uses a given configuration object to determine which path to take. Each instance can be configured separately
  # and used in many places depending on your use cases.
  class PathBrancher
    ##
    # Stores the configuration, an object which implements the PathCOnfiguration interface.
    attr_accessor :configuration

    ##
    # Initializes a new PathBrancher instance with a configuration object that implements the PathConfiguration
    # interface.
    #
    # @param configuration [PathConfiguration] An object that implements the PathConfiguration interface.
    # @see PathBrancher::PathConfiguration
    def initialize(configuration)
      @configuration = configuration
    end

    ##
    # Uses the configuration object, along with the fork_name and metadata, to determine which of the two given paths to
    # take.
    #
    # @param fork_name [String] A name for the fork being determined, registered in the configuration.
    # @param metadata [Hash] A hash of metadata that can be used by the configuration to determine the path.
    # @param left_path [Proc] A proc representing the left path to take if the configuration determines to turn left.
    # @param right_path [Proc] A proc representing the right path to take if the configuration determines to turn right.
    #
    # @return The result of the executed path (left or right).
    def determine_path(fork_name, metadata, left_path, right_path)
      if configuration.turn_left?(fork_name, metadata)
        left_path.call
      else
        right_path.call
      end
    end
  end
end
