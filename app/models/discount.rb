class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name, :description, :percentage_off, :minimum
  validates_numericality_of :percentage_off, :minimum
end
