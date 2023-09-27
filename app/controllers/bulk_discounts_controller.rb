class BulkDiscountsController < ApplicationController
  def index
    @bulk_discounts = BulkDiscount.all
    @merchant = Merchant.find(params[:id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
   @merchant = Merchant.find(params[:id])
   
  end

  def create
    @merchant = Merchant.find(params[:id])
    @bulk_discount = BulkDiscount.create!({
    percentage_discount: params[:add_percentage_discount],
    quantity_threshold: params[:add_quantity_threshold],
    merchant_id: @merchant.id
    })
  
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
  end

  def destroy
    # require 'pry';binding.pry
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    
    redirect_to "/merchants/#{merchant.id}/bulk_discounts"
  end

end
