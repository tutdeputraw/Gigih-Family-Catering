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
    create_order
    create_order_items

    update_total_price(get_total_price)

    render :json => {
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

  def create_order
    @orders = Order.create(
      email: params['email'],
      status: 'NEW'
    )
  end

  def create_order_items
    params[:items].each do |item|
      menu_item = MenuItem.find(item[:id])

      OrderItem.create(
        menu_item: menu_item,
        order: @orders,
        item_price: menu_item.price,
        quantity: item[:quantity]
      )
    end
  end

  def get_total_price
    total_price = 0

    @orders.order_items.each do |order_item|
      total_price = total_price + calculate_price(order_item)
    end

    total_price
  end

  def calculate_price(order_item)
    order_item.item_price * order_item.quantity
  end

  def update_total_price(total_price)
    @orders = Order.find(@orders.id)
    @orders.total_price = total_price
    @orders.save
  end
end

