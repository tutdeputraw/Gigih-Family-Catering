class MenuItemsController < ApplicationController
  def index
    begin
      @menu_items = MenuItem.all

      render_response('')
    rescue Exception => e
      render_error(e.message)
    end
  end

  def show
    begin
      @menu_items = MenuItem.find(params['id'])

      render_response('')
    rescue Exception => e
      render_error(e.message)
    end
  end

  def create
    begin
      @menu_items = MenuItem.new(menu_item_params)
      add_item_categories

      if @menu_items.save
        render_response('new record has successfully created')
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

      update_item_categories

      if @menu_items.save
        render_response('the record has successfully updated')
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
        render_response('the record successfully deleted')
      else
        render_error(@menu_items.errors)
      end
    rescue Exception => e
      render_error(e.message)
    end
  end

  private

  def add_item_categories
    @menu_items.menu_categories << MenuCategory.where(id: params['menu_category_id'])
  end

  def update_item_categories
    @menu_items.menu_categories.replace(MenuCategory.where(id: params['menu_category_id']))
  end

  def menu_item_params
    params.permit(:name, :price, :description)
  end

  def render_error(error)
    render :json => {
      message: 'error has occurred',
      errors: error
    }
  end

  def render_response(message)
    render :json => {
      message: message,
      data: @menu_items
    }, include: [
      :menu_categories => { :only => [:id, :name] }
    ]
  end
end
