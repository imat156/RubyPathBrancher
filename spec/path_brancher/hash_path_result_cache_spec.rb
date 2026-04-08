require 'spec_helper'
require 'path_brancher'
require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/hash_path_result_cache"

RSpec.describe PathBrancher::HashPathResultCache do
  let(:metadata_key) { :username }
  let(:cache_key_method) { ->(path_name, metadata) { "#{path_name}-#{metadata[metadata_key]}" } }
  let(:cache) { PathBrancher::HashPathResultCache.new(cache_key_method) }
  let(:path_name) { 'TestPath' }
  let(:cached_path_name) { 'CachedTestPath' }
  let(:metadata) { { username: 'test_user' } }
  let(:bad_metadata) { { username: 'other_user' } }

  describe '#cached?' do
    before do
      cache.put(cached_path_name, metadata, true)
    end

    it 'returns false for uncached path' do
      expect(cache.cached?(path_name, metadata)).to be false
    end

    it 'returns true for cached path' do
      expect(cache.cached?(cached_path_name, metadata)).to be true
    end

    it 'uses the cache key method to determine cache keys' do
      expect(cache_key_method).to receive(:call).with(cached_path_name, bad_metadata).exactly(3).times
                                                .and_return("#{cached_path_name}-#{bad_metadata[metadata_key]}")
      expect(cache.cached?(cached_path_name, bad_metadata)).to be false
      cache.put(cached_path_name, bad_metadata, true)
      expect(cache.cached?(cached_path_name, bad_metadata)).to be true
    end
  end

  describe '#get' do
    before do
      cache.put(cached_path_name, metadata, true)
    end

    it 'returns nil for uncached path' do
      expect(cache.get(path_name, metadata)).to be_nil
    end

    it 'returns the cached value for cached path' do
      expect(cache.get(cached_path_name, metadata)).to be true
    end

    it 'returns the correct value for multiple cached paths' do
      cache.put(path_name, metadata, false)
      expect(cache.get(cached_path_name, metadata)).to be true
      expect(cache.get(path_name, metadata)).to be false
    end

    it 'uses the cache key method to determine cache keys' do
      expect(cache_key_method).to receive(:call).with(cached_path_name, bad_metadata).exactly(3).times
                                                .and_return("#{cached_path_name}-#{bad_metadata[metadata_key]}")
      expect(cache.get(cached_path_name, bad_metadata)).to be_nil
      cache.put(cached_path_name, bad_metadata, true)
      expect(cache.get(cached_path_name, bad_metadata)).to be true
    end
  end

  describe '#put' do
    before do
      cache.put(cached_path_name, metadata, true)
    end

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
      expect(cache.get(path_name, metadata)).to be false
      expect(cache.get(cached_path_name, metadata)).to be true
    end

    it 'uses the cache key method to determine cache keys' do
      expect(cache_key_method).to receive(:call).with(cached_path_name, bad_metadata).exactly(3).times
                                                .and_return("#{cached_path_name}-#{bad_metadata[metadata_key]}")
      expect(cache.get(cached_path_name, bad_metadata)).to be_nil
      cache.put(cached_path_name, bad_metadata, true)
      expect(cache.get(cached_path_name, bad_metadata)).to be true
    end
  end
end
