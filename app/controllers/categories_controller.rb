class CategoriesController < ApplicationController

	# GET /categories
	def index
		@categories = Category.all
		render json: @categories
 	end

 	# GET /categories/:id
 	def show
 		@category = Category.find(params[:id])
    render json: @category
 	end

 	# GET /categories/:id/webapps
    def webapps
    	@category = Category.find(params[:id])
    end
end
