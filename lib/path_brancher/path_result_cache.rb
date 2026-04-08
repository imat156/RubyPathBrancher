# frozen_string_literal: true

module PathBrancher
  ##
  # Interface module for caching path results. Custom cache implementations must include this module.
  # Examples of cache implementations could include an in-memory hash, a database, or an external caching service.
  module PathResultCache
    ##
    # Checks if the result for the given fork_name and metadata is already cached.
    #
    # @param fork_name [String] A name for the fork being determined, registered in the configuration.
    # @param metadata [Hash] A hash of metadata that can be used by the configuration to determine the path to take.
    #
    # @return [Boolean] true if the result is already cached, false otherwise.
    def cached?(fork_name, metadata)
      # This method should be implemented by the user to check if the result for the given fork_name and metadata is
      # already in this cache.
      raise NotImplementedError, 'You must implement the cached? method in your cache class.'
    end

    ##
    # Retrieves the cached result for the given fork_name and metadata.
    #
    # @param fork_name [String] A name for the fork being determined, registered in the configuration.
    # @param metadata [Hash] A hash of metadata that can be used by the configuration to determine the path to take.
    #
    # @return [Boolean] The cached result indicating whether to turn left (true) or right (false).
    def get(fork_name, metadata)
      # This method should be implemented by the user to retrieve the cached result for the given fork_name and
      # metadata.
      raise NotImplementedError, 'You must implement the get method in your cache class.'
    end

    ##
    # Stores the turn_left boolean for the given fork_name and metadata in the cache.
    #
    # @param fork_name [String] A name for the fork being determined, registered in the configuration.
    # @param metadata [Hash] A hash of metadata that can be used by the configuration to determine the path to take.
    # @param turn_left [Boolean] A boolean indicating whether to turn left (true) or right (false) to cache.
    def put(fork_name, metadata, turn_left)
      # This method should be implemented by the user to store the result for the given fork_name and metadata in the
      # cache.
      raise NotImplementedError, 'You must implement the put method in your cache class.'
    end
  end
end
