class CategoriesController < ApplicationController

    @@nb_webapp_featured = 3

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

    # GET /categories/:id/featured_webapp
    def featured_webapp
        @category = Category.find(params[:id])
        @webapp = @category.featured_webapp(1).first
        render "webapps/show"
    end

    # GET /categories/:id/featured_webapps
    def featured_webapps
        @category = Category.find(params[:id])
        @webapp = @category.featured_webapp(@@nb_webapp_featured)
        render "webapps/show"
    end


end
