class MenuItemsController < ApplicationController
  def index
    menu_items = MenuItem.all

    render :json => {
      message: '',
      data: menu_items
    }, include: [
      :menu_categories => { :only => [:id, :name] }
    ]
  end

  def show
    menu_item = MenuItem.find(params['id'])

    render :json => {
      message: '',
      data: menu_item
    }, include: [
      :menu_categories => { :only => [:id, :name] }
    ]
  end

  def create
    menu_item = MenuItem.new(menu_item_params)
    menu_item.menu_categories << MenuCategory.where(id: params['menu_category_id'])

    if menu_item.save
      render :json => {
        message: 'new record successfully created',
        data: menu_item
      }
    end
  end

  def update
    menu_item = MenuItem.find(params['id'])

    menu_item.update(menu_item_params)
    menu_item.menu_categories.replace(MenuCategory.where(id: params['menu_category_id']))

    if menu_item.save
      render :json => {
        message: 'the record successfully updated',
        data: menu_item
      }, include: [
        :menu_categories => { :only => [:id, :name] }
      ]
    end
  end

  def destroy
    menu_item = MenuItem.find(params['id'])
    menu_item.menu_categories.clear

    if menu_item.destroy
      render :json => {
        message: 'the record successfully deleted',
      }
    end
  end

  private

  def menu_item_params
    params.permit(:name, :price, :description)
  end
end
