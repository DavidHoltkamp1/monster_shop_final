class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = Merchant.find(current_user.merchant.id).discounts
  end

  def new
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to "/merchant/discounts"
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to '/merchant/discounts/new'
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      redirect_to "/merchant/discounts"
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to '/merchant/discounts'
  end
end


  private

    def discount_params
      params.permit(:name, :description, :percentage_off, :minimum, :maximum)
    end
