class MenuCategoriesController < ApplicationController
  def index
    begin
      @menu_categories = MenuCategory.all

      render :json => {
        data: @menu_categories
      }
    rescue Exception => e
      render_error(e.message)
    end
  end

  def show
    begin
      @menu_category = MenuCategory.find(params['id'])

      render :json => {
        data: @menu_category
      }
    rescue Exception => e
      render_error(e.message)
    end
  end

  def create
    begin
      @menu_category = MenuCategory.new(menu_category_params)

      if @menu_category.save
        render :json => {
          message: 'menu created',
          data: @menu_category
        }
      end
    rescue Exception => e
      render_error(e.message)
    end
  end

  private

  def menu_category_params
    params.require(:menu_category).permit(:name)
  end

  def render_error(error)
    render :json => {
      message: 'error has occurred',
      errors: error
    }
  end
end
