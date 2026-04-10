# frozen_string_literal: true

require 'spec_helper'
require 'path_brancher'
require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/path_configuration"

RSpec.describe PathBrancher::PathConfiguration do
  let(:configuration) { Class.new { include PathBrancher::PathConfiguration }.new }

  describe '#turn_left?' do
    it 'raises NotImplementedError when called' do
      expect { configuration.turn_left?('TestPath', {}) }.to raise_error(NotImplementedError)
    end
  end
end
