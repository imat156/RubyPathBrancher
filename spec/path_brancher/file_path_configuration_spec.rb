# frozen_string_literal: true

require 'spec_helper'
require 'path_brancher'
require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/file_path_configuration"
require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/path_result_cache"

RSpec.describe PathBrancher::FilePathConfiguration do
  subject(:configuration) { described_class.new(file_path, path_result_cache, random_generator) }

  let(:file_path) { 'spec/test_path_config.yml' }
  let(:path_result_cache) { Class.new { include PathBrancher::PathResultCache }.new }
  let(:random_generator) { instance_double(Random) }
  let(:metadata) { {} }

  describe '#turn_left?' do
    it 'raises an error if the fork name is not defined in the configuration' do
      expect { configuration.turn_left?('undefined_path', metadata) }.to raise_error(
        ArgumentError, "Fork name 'undefined_path' is not defined in this configuration"
      )
    end

    context 'when the path has a turn_left_flag' do
      let(:path_name) { 'turn_left_flag_path' }

      it 'returns true when turn_left_flag is true' do
        allow(YAML).to receive(:load_file).with(file_path).and_return(
          { path_name => { 'turn_left_flag' => true } }
        )
        expect(configuration.turn_left?(path_name, metadata)).to be true
      end

      it 'returns false when turn_left_flag is false' do
        allow(YAML).to receive(:load_file).with(file_path).and_return(
          { path_name => { 'turn_left_flag' => false } }
        )
        expect(configuration.turn_left?(path_name, metadata)).to be false
      end
    end

    context 'when the path has a turn_left_percentage' do
      let(:path_name) { 'percent_path' }

      context 'and turn_left_percent_cache is false' do
        before do
          allow(YAML).to receive(:load_file).with(file_path).and_return(
            { path_name => { 'turn_left_percentage' => 33.0, 'turn_left_percent_cache' => false } }
          )
        end

        it 'returns true if the percentage is greater than rand' do
          allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(32.9)
          expect(configuration.turn_left?(path_name, metadata)).to be true
        end

        it 'returns true if the percentage is equal to rand' do
          allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(33.0)
          expect(configuration.turn_left?(path_name, metadata)).to be true
        end


        it 'returns false if the percentage is less than rand' do
          allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(33.1)
          expect(configuration.turn_left?(path_name, metadata)).to be false
        end

        it 'does not cache the result' do
          allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(32.9)
          expect(configuration.turn_left?(path_name, metadata)).to be true
          allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(33.1)
          expect(configuration.turn_left?(path_name, metadata)).to be false
        end
      end

      context 'and turn_left_percent_cache is true' do
        before do
          allow(YAML).to receive(:load_file).with(file_path).and_return(
            { path_name => { 'turn_left_percentage' => 66.0, 'turn_left_percent_cache' => true } }
          )
        end

        context 'and the path result is not cached' do
          before do
            allow(path_result_cache).to receive(:cached?).with(path_name, metadata).and_return(false)
            allow(path_result_cache).to receive(:put).with(path_name, metadata, boolean)
          end

          it 'returns true if the percentage is greater than rand' do
            allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(65.9)
            expect(configuration.turn_left?(path_name, metadata)).to be true
          end

          it 'returns true if the percentage is equal to rand' do
            allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(66.0)
            expect(configuration.turn_left?(path_name, metadata)).to be true
          end


          it 'returns false if the percentage is less than rand' do
            allow(random_generator).to receive(:rand).with(0.0..100.0).and_return(66.1)
            expect(configuration.turn_left?(path_name, metadata)).to be false
          end
        end

        context 'and the path result is cached' do
          before do
            allow(path_result_cache).to receive(:cached?).with(path_name, metadata).and_return(true)
          end

          it 'returns the cached value' do
            allow(random_generator).to receive(:rand).and_return(101.0)
            allow(path_result_cache).to receive(:get).with(path_name, metadata).and_return(true)
            expect(configuration.turn_left?(path_name, metadata)).to be true
            expect(random_generator).not_to have_received(:rand)
          end
        end
      end
    end
  end
end
