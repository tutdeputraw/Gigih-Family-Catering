class MenuItemsController < ApplicationController
  def index
    @menu_items = MenuItem.all

    render :json => {
      message: '',
      data: @menu_items
    }, include: [
      :menu_categories => { :only => [:id, :name] }
    ]
  end

  def show
    @menu_items = MenuItem.find(params['id'])

    render :json => {
      message: '',
      data: @menu_items
    }, include: [
      :menu_categories => { :only => [:id, :name] }
    ]
  end

  def create
    @menu_items = MenuItem.new(menu_item_params)
    @menu_items.menu_categories << MenuCategory.where(id: params['menu_category_id'])

    if @menu_items.save
      render :json => {
        message: 'new record successfully created',
        data: @menu_items
      }
    else
      render :json => {
        message: 'error has occured',
        errors: @menu_items.errors
      }
    end
  end

  def update
    begin
      @menu_items = MenuItem.find(params['id'])

      @menu_items.update(menu_item_params)
      @menu_items.menu_categories.replace(MenuCategory.where(id: params['menu_category_id']))

      if @menu_items.save
        render :json => {
          message: 'the record successfully updated',
          data: @menu_items
        }, include: [
          :menu_categories => { :only => [:id, :name] }
        ]
      end
    rescue Exception => e
      render :json => {
        errors: e.message
      }
    end
  end

  def destroy
    @menu_items = MenuItem.find(params['id'])
    @menu_items.menu_categories.clear

    if @menu_items.destroy
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
