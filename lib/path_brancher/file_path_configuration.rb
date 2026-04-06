require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/path_configuration"
require 'yaml'

class PathBrancher::FilePathConfiguration
  include PathBrancher::PathConfiguration

  def initialize(file_path, path_cache = nil, random_generator = Random.new)
    @configuration_data = load_configuration(file_path)
    @path_cache = path_cache
    @random_generator = random_generator
  end

  def turn_left?(path_name, metadata)
    if @configuration_data.key?(path_name)
      if @configuration_data[path_name].key?('turn_left_flag')
        @configuration_data[path_name]['turn_left_flag']
      elsif @configuration_data[path_name].key?('turn_left_percentage')
        if @configuration_data[path_name]['turn_left_percent_cache']
          if @path_cache.cached?(path_name, metadata)
            @path_cache.get(path_name, metadata)
          else
            result = @configuration_data[path_name]['turn_left_percentage'] >= random_percentage
            @path_cache.put(path_name, metadata, result)
            result
          end
        else
          @configuration_data[path_name]['turn_left_percentage'] >= random_percentage
        end
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