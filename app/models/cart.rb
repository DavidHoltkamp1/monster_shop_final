class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def discounted_subtotal(item_id)
    item = Item.find(item_id)
    discount = item.discount(@contents[item_id.to_s])
    total_discount = subtotal_of(item_id) * (discount.percentage_off.to_f / 100)
    subtotal_of(item_id) - total_discount
  end

  def discount_applied?
    @contents.any? do |item_id, quantity|
      item = Item.find(item_id)
      item.discount(quantity)
    end
  end

  def discounted_grand_total
    @contents.sum do |item_id, quantity|
      item = Item.find(item_id)
      if item.discount(quantity)
        discounted_subtotal(item_id)
      else
        subtotal_of(item_id)
      end
    end
  end
end
