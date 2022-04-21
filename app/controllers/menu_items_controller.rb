class MenuItemsController < ApplicationController
  def index
    begin
      @menu_items = MenuItem.all

      render :json => {
        message: '',
        data: @menu_items
      }, include: [
        :menu_categories => { :only => [:id, :name] }
      ]
    rescue Exception => e
      render_error(e.message)
    end
  end

  def show
    begin
      @menu_items = MenuItem.find(params['id'])

      render :json => {
        message: '',
        data: @menu_items
      }, include: [
        :menu_categories => { :only => [:id, :name] }
      ]
    rescue Exception => e
      render_error(e.message)
    end
  end

  def create
    begin
      @menu_items = MenuItem.new(menu_item_params)
      @menu_items.menu_categories << MenuCategory.where(id: params['menu_category_id'])

      if @menu_items.save
        render :json => {
          message: 'new record successfully created',
          data: @menu_items
        }
      else
        render_error(@menu_items.errors)
      end
    rescue Exception => e
      render_error(e.message)
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
      else
        render_error(@menu_items.errors)
      end
    rescue Exception => e
      render_error(e.message)
    end
  end

  def destroy
    begin
      @menu_items = MenuItem.find(params['id'])
      @menu_items.menu_categories.clear

      if @menu_items.destroy
        render :json => {
          message: 'the record successfully deleted',
        }
      else
        render_error(@menu_items.errors)
      end
    rescue Exception => e
      render_error(e.message)
    end
  end

  private

  def menu_item_params
    params.permit(:name, :price, :description)
  end

  def render_error(error)
    render :json => {
      message: 'error has occured',
      errors: error
    }
  end
end
