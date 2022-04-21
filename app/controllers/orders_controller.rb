class OrdersController < ApplicationController
  def index
    if has_email_param?
      @orders = Order.where(:email => params[:email])
    elsif has_total_price_param?
      @orders = Order.where('total_price > ?', params[:total_price])
    elsif has_range_date_param?
      @orders = Order.where(:created_at => params[:start_date]..params[:end_date])
    else
      @orders = Order.all
    end

    render :json => {
      message: '',
      data: @orders
    }, :include => [
      :order_items
    ]
  end

  def create
    @orders = Order.create(
      email: params['email'],
      total_price: 0,
      status: 'NEW'
    )

    total_price = 0

    params[:items].each do |item|
      menu_item = MenuItem.find(item[:id])
      total_price = total_price + (menu_item.price * item[:quantity])

      OrderItem.create(
        menu_item: menu_item,
        order: @orders,
        item_price: menu_item.price,
        quantity: item[:quantity]
      )
    end

    @orders = Order.find(@orders.id)
    @orders.total_price = total_price
    @orders.save

    render :json => {
      x: total_price,
      message: 'new record successfully created',
      data: @orders
    }, include: [
      :order_items => { :only => [:menu_item_id, :item_price, :quantity] }
    ]
  end

  private

  def has_email_param?
    params.has_key?(:email)
  end

  def has_total_price_param?
    params.has_key?(:total_price)
  end

  def has_range_date_param?
    params.has_key?(:start_date) && params.has_key?(:end_date)
  end
end

