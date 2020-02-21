# frozen_string_literal: true

RSpec.describe Prawn::LabelSheet::Configuration do
  describe 'new instance' do
    subject(:instance) { Prawn::LabelSheet::Configuration.new }

    it 'has a layout named "Avery7160"' do
      expect(instance.layouts).to have_key('Avery7160')
    end

    it 'has default_layout "Avery7160"' do
      expect(instance.default_layout).to eq 'Avery7160'
    end
  end
end
