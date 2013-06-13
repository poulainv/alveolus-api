class CategoriesController < BaseController
    
    caches_action :categories_all_webapps, :categories_featured_webapps
    cache_sweeper :category_sweeper
    
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

    # GET /categories/:id/featured_webapp
    def featured_webapp
        @category = Category.find(params[:id])
        @webapp = @category.featured_webapp(1).first
        render json: @webapp, :serializer => WebappLazySerializer
    end

    # GET /categories/:id/featured_webapps
    def featured_webapps
        @category = Category.find(params[:id])
        @webapps = @category.featured_webapp(@@nb_webapp_featured)
        render json: @webapps, :each_serializer => WebappLazySerializer
    end

    # GET /categories/featured_webapps
    def categories_featured_webapps
        @categories = Category.all
        render json: @categories, :each_serializer => CategorySerializer
    end

        # GET /categories/all_webapps
    def categories_all_webapps
        @categories = Category.all
        render json: @categories, :each_serializer => CategoryAllSerializer
    end


end
