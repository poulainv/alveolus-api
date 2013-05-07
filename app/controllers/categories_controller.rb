class CategoriesController < ApplicationController

	# GET /categories
	def index
		@categories = Category.all
		render json: @categories
 	end

 	def show
 		@category = Category.find(params[:id])
    render json: @category
 	end
end
