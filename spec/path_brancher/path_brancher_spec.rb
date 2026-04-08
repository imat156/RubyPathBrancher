require 'spec_helper'
require 'path_brancher'
require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/path_brancher"

RSpec.describe PathBrancher::PathBrancher do
  describe '.determine_path' do
    let(:configuration) { double('configuration') }
    let(:path_brancher) { PathBrancher::PathBrancher.new(configuration) }
    let(:path_name) { 'AwesomePath' }
    let(:call_metadata) { {} }
    let(:left_path) { -> { 'Left Path Called' } }
    let(:right_path) { -> { 'Right Path Called' } }

    context 'when the left path is enabled' do
      before do
        allow(configuration).to receive(:turn_left?).with(path_name, call_metadata).and_return(true)
      end

      it 'calls the left path' do
        expect(left_path).to receive(:call)
        path_brancher.determine_path(path_name, call_metadata, left_path, right_path)
      end

      it 'returns the result of the left path' do
        expect(path_brancher.determine_path(path_name, call_metadata, left_path,
                                            right_path)).to eq('Left Path Called')
      end
    end

    context 'when the left path is disabled' do
      before do
        allow(configuration).to receive(:turn_left?).with(path_name, call_metadata).and_return(false)
      end

      it 'calls the right path' do
        expect(right_path).to receive(:call)
        path_brancher.determine_path(path_name, call_metadata, left_path, right_path)
      end

      it 'returns the result of the right path' do
        expect(path_brancher.determine_path(path_name, call_metadata, left_path,
                                            right_path)).to eq('Right Path Called')
      end
    end
  end
end
