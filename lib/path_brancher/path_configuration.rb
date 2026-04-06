module PathBrancher::PathConfiguration
  def turn_left?(path_name, metadata)
    # This method should be implemented by the user to determine whether to turn left or right based on the path_name and metadata.
    # For example, it could check a configuration file, an environment variable, or any other logic to decide the path.
    raise NotImplementedError, "You must implement the turn_left? method in your configuration class."
  end
end