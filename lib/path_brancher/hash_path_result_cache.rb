# frozen_string_literal: true

require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/path_result_cache"

module PathBrancher
  ##
  # A simple in-memory implementation of the PathResultCache interface, using a hash to store cached results. The cache
  # key is generated using a provided cache_key_method, which defaults to a combination of the fork name and metadata.
  class HashPathResultCache
    include PathBrancher::PathResultCache

    ##
    # Initializes the HashPathResultCache with an optional cache key method. The cache key method should take a
    # fork_name and metadata as arguments and return a unique key for caching the result. If no cache key method is
    # provided, a default method that combines the fork name and metadata will be used.
    #
    # @param cache_key_method [Proc] (optional) A method that generates a cache key from the fork name and metadata.
    def initialize(cache_key_method = method(:default_cache_key))
      @cache = {}
      @cache_key_method = cache_key_method
    end

    ##
    # Determines whether a cached result exists for the given fork name and metadata.
    #
    # @param fork_name [String] The name of the fork to check for a cached result.
    # @param metadata [Hash] A hash of metadata that may be used for further refining the cache key.
    #
    # @return [Boolean] true if a cached result exists, false otherwise.
    def cached?(fork_name, metadata)
      @cache.key?(@cache_key_method.call(fork_name, metadata))
    end

    ##
    # Retrieves the cached result for the given fork name and metadata.
    #
    # @param fork_name [String] The name of the fork to retrieve the cached result for.
    # @param metadata [Hash] A hash of metadata that may be used for further refining the cache key.
    #
    # @return [Boolean] The cached result for the given fork name and metadata.
    def get(fork_name, metadata)
      @cache[@cache_key_method.call(fork_name, metadata)]
    end

    ##
    # Caches the result for the given fork name and metadata.
    #
    # @param fork_name [String] The name of the fork to cache the result for.
    # @param metadata [Hash] A hash of metadata that may be used for further refining the cache key.
    # @param turn_left_result [Boolean] The result to cache for the given fork name and metadata.
    def put(fork_name, metadata, turn_left_result)
      @cache[@cache_key_method.call(fork_name, metadata)] = turn_left_result
    end

    private

    ##
    # Default cache key method that combines the fork name and metadata into a string key.
    #
    # @param fork_name [String] The name of the fork to generate the cache key for.
    # @param metadata [Hash] A hash of metadata to include in the cache key through simple stringification.
    #
    # @return [String] A string key generated from the fork name and metadata.
    def default_cache_key(fork_name, metadata)
      "##{fork_name}-#{metadata}"
    end
  end
end
