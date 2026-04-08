require 'spec_helper'
require 'path_brancher'
require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/file_path_configuration"
require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/path_result_cache"

RSpec.describe PathBrancher::FilePathConfiguration do
  let(:path_result_cache) { Class.new { include PathBrancher::PathResultCache }.new }
  let(:random_generator) { instance_double(Random) }
  let(:configuration) { PathBrancher::FilePathConfiguration.new('spec/test_path_config.yml', path_result_cache, random_generator) }
  let(:left_flag_path_name) { 'left_flag_path' }
  let(:right_flag_path_name) { 'right_flag_path' }
  let(:percent_path_name) { 'percent_path' }
  let(:cached_percent_path_name) { 'cached_percent_path' }
  let(:metadata) { {} }

  describe '#turn_left?' do
    context 'when the path has a turn_left_flag' do
      it 'returns the value of turn_left_flag' do
        expect(configuration.turn_left?(left_flag_path_name, metadata)).to be true
        expect(configuration.turn_left?(right_flag_path_name, metadata)).to be false
      end
    end

    context 'when the path has a turn_left_percentage' do
      context 'and turn_left_percent_cache is false' do
        it 'returns true if the percentage is greater than rand' do
          allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(32.9)
          expect(configuration.turn_left?(percent_path_name, metadata)).to be true
        end

        it 'returns true if the percentage is equal to rand' do
          allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(33.0)
          expect(configuration.turn_left?(percent_path_name, metadata)).to be true
        end


        it 'returns false if the percentage is less than rand' do
          allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(33.1)
          expect(configuration.turn_left?(percent_path_name, metadata)).to be false
        end
      end

      context 'and turn_left_percent_cache is true' do
        context 'and the path result is not cached' do
          before do
            allow(path_result_cache).to receive(:cached?).with(cached_percent_path_name, metadata).and_return(false)
            allow(path_result_cache).to receive(:put).with(cached_percent_path_name, metadata, boolean)
          end

          it 'returns true if the percentage is greater than rand' do
            allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(65.9)
            expect(configuration.turn_left?(cached_percent_path_name, metadata)).to be true
          end

          it 'returns true if the percentage is equal to rand' do
            allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(66.0)
            expect(configuration.turn_left?(cached_percent_path_name, metadata)).to be true
          end


          it 'returns false if the percentage is less than rand' do
            allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(66.1)
            expect(configuration.turn_left?(cached_percent_path_name, metadata)).to be false
          end
        end

        context 'and the path result is cached' do
          before do
            allow(path_result_cache).to receive(:cached?).with(cached_percent_path_name, metadata).and_return(true)
          end

          it 'returns the cached value' do
            expect(random_generator).not_to receive(:rand)
            allow(path_result_cache).to receive(:get).with(cached_percent_path_name, metadata).and_return(true)
            expect(configuration.turn_left?(cached_percent_path_name, metadata)).to be true
          end
        end
      end
    end
  end
end
