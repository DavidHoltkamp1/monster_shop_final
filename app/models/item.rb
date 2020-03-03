class Item < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews, dependent: :destroy

  validates_presence_of :name,
                        :description,
                        :image,
                        :price,
                        :inventory

  def self.active_items
    where(active: true)
  end

  def self.by_popularity(limit = nil, order = "DESC")
    left_joins(:order_items)
    .select('items.id, items.name, COALESCE(sum(order_items.quantity), 0) AS total_sold')
    .group(:id)
    .order("total_sold #{order}")
    .limit(limit)
  end

  def sorted_reviews(limit = nil, order = :asc)
    reviews.order(rating: order).limit(limit)
  end

  def average_rating
    reviews.average(:rating)
  end

  def get_discounts
    merchant_discounts = merchant.discounts.each do |discount|
      Discount.find(discount.id)
    end
    merchant_discounts
  end

  def sorted_discounts
     sorted_discounts = get_discounts.sort_by do |discount|
      discount.percentage_off
    end
    sorted_discounts.reverse
  end

  def discount(item_quantity)
    sorted_discounts.find do |discount|
      item_quantity >= discount.minimum
    end
  end
end
