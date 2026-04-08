# frozen_string_literal: true

require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/path_result_cache"

module PathBrancher
  class HashPathResultCache
    include PathBrancher::PathResultCache

    def initialize(cache_key_method = method(:default_cache_key))
      @cache = {}
      @cache_key_method = cache_key_method
    end

    def cached?(fork_name, metadata)
      @cache.key?(@cache_key_method.call(fork_name, metadata))
    end

    def get(fork_name, metadata)
      @cache[@cache_key_method.call(fork_name, metadata)]
    end

    def put(fork_name, metadata, turn_left_result)
      @cache[@cache_key_method.call(fork_name, metadata)] = turn_left_result
    end

    private

    def default_cache_key(fork_name, metadata)
      "##{fork_name}-#{metadata}"
    end
  end
end
