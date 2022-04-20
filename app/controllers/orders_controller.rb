class OrdersController < ApplicationController
  def create
    @orders = Order.create(
      email: params['email'],
      total_price: 0,
      status: 'NEW'
    )

    params[:items].each do |item|
      menu_item = MenuItem.find(item[:id])

      OrderItem.create(
        menu_item: menu_item,
        order: @orders,
        item_price: menu_item.price,
        quantity: item[:quantity]
      )
    end

    render :json => {
      message: 'new record successfully created',
      data: @orders
    }, include: [
      :order_items
    ]
  end

  private
end
