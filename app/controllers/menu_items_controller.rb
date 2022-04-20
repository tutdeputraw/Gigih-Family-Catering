class MenuItemsController < ApplicationController
  def index
    @menu_items = MenuItem.all

    render :json => {
      data: @menu_items
    }, include: [
      :menu_categories => { :only => [:id, :name] }
    ]
  end

  def show
    @menu_items = MenuItem.find(params['id'])

    render :json => {
      data: @menu_items
    }, include: [
      :menu_categories => { :only => [:id, :name] }
    ]
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)
    @menu_item.menu_categories << MenuCategory.where(id: params['menu_category_id'])

    if @menu_item.save
      render :json => {
        message: 'new record created successfully',
        data: @menu_item
      }
    else
      render :json => {
        message: 'create new record failed',
      }
    end
  end

  private

  def menu_item_params
    params.permit(:name, :price, :description)
  end
end
