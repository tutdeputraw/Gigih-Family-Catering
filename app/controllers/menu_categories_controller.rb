class MenuCategoriesController < ApplicationController
  def index
    @menu_categories = MenuCategory.all

    render :json => {
      data: @menu_categories
    }
  end

  def create
    @menu_category = MenuCategory.new(menu_category_params)

    if @menu_category.save
      render :json => {
        message: 'menu created',
        data: @menu_category
      }
    end
  end

  private

  def menu_category_params
    params.require(:menu_category).permit(:name)
  end
end
