require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/path_result_cache"

class PathBrancher::HashPathResultCache
  include PathBrancher::PathResultCache

  def initialize(cache_key_method = method(:default_cache_key))
    @cache = {}
    @cache_key_method = cache_key_method
  end

  def cached?(path_name, metadata)
    @cache.key?(@cache_key_method.call(path_name, metadata))
  end

  def get(path_name, metadata)
    @cache[@cache_key_method.call(path_name, metadata)]
  end

  def put(path_name, metadata, turn_left_result)
    @cache[@cache_key_method.call(path_name, metadata)] = turn_left_result
  end

  private

  def default_cache_key(path_name, metadata)
    path_name
  end
end