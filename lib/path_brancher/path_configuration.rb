# frozen_string_literal: true

module PathBrancher
  ##
  # Interface module for path configurations. Custom configuration implementations must include this module.
  module PathConfiguration
    ##
    # Determines whether to turn left or right at a given fork based on the fork_name and metadata.
    #
    # @param fork_name [String] A name for the fork being determined, registered in this configuration.
    # @param metadata [Hash] A hash of metadata that can be used by the configuration to determine the path to take.
    #
    # @return [Boolean] true if the left path should be taken, false if the right path should be taken.
    def turn_left?(fork_name, metadata)
      # This method should be implemented by the user to determine whether to turn left or right based on the fork_name
      # and metadata. For example, it could check a configuration file, an environment variable, an external service, or
      # any other logic to decide the path.
      raise NotImplementedError, 'You must implement the turn_left? method in your configuration class.'
    end
  end
end
