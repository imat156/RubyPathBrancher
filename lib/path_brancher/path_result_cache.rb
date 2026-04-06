module PathBrancher::PathResultCache
    def cached?(path_name, metadata)
      # This method should be implemented by the user to check if the result for the given path_name and metadata is already cached.
      # For example, it could check a hash, a database, or any other caching mechanism to determine if the result is available.
      raise NotImplementedError, "You must implement the cached? method in your cache class."
    end

    def get(path_name, metadata)
      # This method should be implemented by the user to retrieve the cached result for the given path_name and metadata.
      # For example, it could return the cached value from a hash, a database, or any other caching mechanism.
      raise NotImplementedError, "You must implement the get method in your cache class."
    end

    def put(path_name, metadata, turn_left)
      # This method should be implemented by the user to store the result for the given path_name and metadata in the cache.
      # For example, it could store the value in a hash, a database, or any other caching mechanism.
      raise NotImplementedError, "You must implement the put method in your cache class."
    end
end