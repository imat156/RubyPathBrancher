# frozen_string_literal: true

require 'spec_helper'
require 'path_brancher'
require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/path_brancher"
require "#{PathBrancher::RUBY_LIBRARY_PATH}/path_brancher/path_configuration"

RSpec.describe PathBrancher::PathBrancher do
  describe '#determine_path' do
    subject(:path_brancher) { described_class.new(configuration) }

    let(:configuration) { instance_double(PathBrancher::PathConfiguration) }
    let(:path_name) { 'AwesomePath' }
    let(:call_metadata) { {} }
    let(:left_path) { -> { 'Left Path Called' } }
    let(:right_path) { -> { 'Right Path Called' } }

    context 'when the left path is enabled' do
      it 'returns the result of the left path' do
        allow(configuration).to receive(:turn_left?).with(path_name, call_metadata).and_return(true)
        expect(path_brancher.determine_path(path_name, call_metadata, left_path,
                                            right_path)).to eq('Left Path Called')
      end
    end

    context 'when the left path is disabled' do
      it 'returns the result of the right path' do
        allow(configuration).to receive(:turn_left?).with(path_name, call_metadata).and_return(false)
        expect(path_brancher.determine_path(path_name, call_metadata, left_path,
                                            right_path)).to eq('Right Path Called')
      end
    end
  end
end
