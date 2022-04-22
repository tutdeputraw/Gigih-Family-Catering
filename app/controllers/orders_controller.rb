class OrdersController < ApplicationController
  def index
    begin
      if has_param?('email')
        @orders = Order.where(:email => params[:email])
      elsif has_param?('total_price')
        @orders = Order.where('total_price > ?', params[:total_price])
      elsif has_param?('start_date') && has_param?('end_date')
        @orders = Order.where(:created_at => params[:start_date]..params[:end_date])
      else
        @orders = Order.all
      end

      render_response
    rescue Exception => e
      render_error(e.message)
    end
  end

  def create
    begin
      @orders = Order.new(
        email: params['email'],
        total_price: 0,
        status: 'NEW'
      )

      unless @orders.save
        render_error(@orders.errors) and return
      end

      create_order_items

      update_total_price(get_total_price)

      render_response
    rescue Exception => e
      render_error(e.message)
    end
  end

  def update
    begin
      unless has_param?('status')
        render_error("body query 'status' is required to update the order status") and return
      end

      @orders = Order.find(params['id'])

      @orders.update_attribute(:status, params['status'])

      if @orders.save
        render_response
      else
        render_error(@orders.errors)
      end
    rescue Exception => e
      render_error(e.message)
    end
  end

  private

  def has_param?(keyword)
    params.has_key?(keyword)
  end

  def render_error(error)
    render :json => {
      message: 'error has occurred',
      errors: error
    }
  end

  def render_response
    render :json => {
      message: 'new record successfully created',
      data: @orders
    }, include: [
      :order_items => { :only => [:menu_item_id, :item_price, :quantity] }
    ]
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

