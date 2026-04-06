require 'spec_helper'
require 'path_brancher'
require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/path_result_cache"

RSpec.describe PathBrancher::PathResultCache do
  let(:cache) { Class.new { include PathBrancher::PathResultCache }.new }
  let(:path_name) { "TestPath" }
  let(:metadata) { {} }

  describe "#cached?" do
    it "raises NotImplementedError when called" do
      expect { cache.cached?(path_name, metadata) }.to raise_error(NotImplementedError)
    end
  end

  describe "#get" do
    it "raises NotImplementedError when called" do
      expect { cache.get(path_name, metadata) }.to raise_error(NotImplementedError)
    end
  end

  describe "#put" do
    it "raises NotImplementedError when called" do
      expect { cache.put(path_name, metadata, true) }.to raise_error(NotImplementedError)
    end
  end
end