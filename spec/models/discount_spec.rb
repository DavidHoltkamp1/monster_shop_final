require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :percentage_off}
    it {should validate_presence_of :minimum}
    it {should validate_presence_of :maximum}
  end
end 
