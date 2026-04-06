class PathBrancher::PathBrancher
  attr_accessor :configuration

  def initialize(configuration)
    @configuration = configuration
  end

  def determine_path(path_name, metadata, left_path, right_path)
    if (configuration.turn_left?(path_name, metadata))
      left_path.call
    else
      right_path.call
    end
  end
end