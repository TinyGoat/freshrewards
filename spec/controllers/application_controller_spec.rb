require 'spec_helper'

describe ApplicationController do

  describe '#current_customer' do

    it 'returns the first Customer' do
      expect(Customer).to receive(:first)

      controller.current_customer
    end
  end
end

