class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.new
    order.save
      cart.items.each do |item|
        if item.discount(cart.count_of(item.id))
          discount = item.discount(cart.count_of(item.id))
          adjusted_price = item.discounted_price(discount.percentage_off)
        else
          adjusted_price = item.price
        end
        order.order_items.create({
          item: item,
          quantity: cart.count_of(item.id),
          price: adjusted_price
          })
      end
    session.delete(:cart)
    flash[:notice] = "Order created successfully!"
    redirect_to '/profile/orders'
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end
end
