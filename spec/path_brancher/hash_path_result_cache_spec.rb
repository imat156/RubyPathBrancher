# frozen_string_literal: true

require 'spec_helper'
require 'path_brancher'
require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/hash_path_result_cache"

RSpec.describe PathBrancher::HashPathResultCache do
  subject(:cache) { described_class.new(cache_key_method) }

  let(:metadata_key) { :username }
  let(:cache_key_method) { ->(path_name, metadata) { "#{path_name}-#{metadata[metadata_key]}" } }
  let(:path_name) { 'TestPath' }
  let(:metadata) { { username: 'test_user' } }
  let(:bad_metadata) { { username: 'other_user' } }

  describe '#cached?' do
    it 'returns false for uncached path' do
      expect(cache.cached?(path_name, metadata)).to be false
    end

    it 'returns true for cached path' do
      cache.put(path_name, metadata, true)
      expect(cache.cached?(path_name, metadata)).to be true
    end

    it 'uses the cache key method to determine cache keys' do
      allow(cache_key_method).to receive(:call).with(path_name, bad_metadata).and_return('Caching!')
      expect(cache.cached?(path_name, bad_metadata)).to be false
      cache.put(path_name, bad_metadata, true)
      expect(cache.cached?(path_name, bad_metadata)).to be true
      expect(cache_key_method).to have_received(:call).with(path_name, bad_metadata).exactly(3).times
    end
  end

  describe '#get' do
    it 'returns nil for uncached path' do
      expect(cache.get(path_name, metadata)).to be_nil
    end

    it 'returns the cached value for cached path' do
      cache.put(path_name, metadata, true)
      expect(cache.get(path_name, metadata)).to be true
    end

    it 'returns the correct value for multiple cached paths' do
      cache.put(path_name, metadata, true)
      cache.put("Other#{path_name}", metadata, false)
      expect(cache.get(path_name, metadata)).to be true
    end

    it 'uses the cache key method to determine cache keys' do
      allow(cache_key_method).to receive(:call).with(path_name, bad_metadata).and_return('Caching!')
      expect(cache.cached?(path_name, bad_metadata)).to be false
      cache.put(path_name, bad_metadata, true)
      expect(cache.cached?(path_name, bad_metadata)).to be true
      expect(cache_key_method).to have_received(:call).with(path_name, bad_metadata).exactly(3).times
    end
  end

  describe '#put' do
    it 'stores the value in the cache' do
      cache.put(path_name, metadata, true)
      expect(cache.get(path_name, metadata)).to be true
    end

    it 'overwrites existing value in the cache' do
      cache.put(path_name, metadata, true)
      cache.put(path_name, metadata, false)
      expect(cache.get(path_name, metadata)).to be false
    end

    it 'does not overwrite other cached values' do
      cache.put(path_name, metadata, false)
      cache.put("Other#{path_name}", metadata, true)
      expect(cache.get(path_name, metadata)).to be false
    end

    it 'uses the cache key method to determine cache keys' do
      allow(cache_key_method).to receive(:call).with(path_name, bad_metadata).and_return('Caching!')
      expect(cache.cached?(path_name, bad_metadata)).to be false
      cache.put(path_name, bad_metadata, true)
      expect(cache.cached?(path_name, bad_metadata)).to be true
      expect(cache_key_method).to have_received(:call).with(path_name, bad_metadata).exactly(3).times
    end
  end
end
