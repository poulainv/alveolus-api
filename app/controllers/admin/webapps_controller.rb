class Admin::WebappsController < ApplicationController
  # GET /admin/webapps
  # GET /admin/webapps.json
  http_basic_authenticate_with :name => "admin", :password => "quenelle"
  
  def index
    @admin_webapps = Webapp.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_webapps }
    end
  end

  # GET /admin/webapps/1
  # GET /admin/webapps/1.json
  def show
    @admin_webapp = Webapp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_webapp }
    end
  end

  # GET /admin/webapps/new
  # GET /admin/webapps/new.json
  def new
    @admin_webapp = Webapp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_webapp }
    end
  end

  # GET /admin/webapps/1/edit
  def edit
    @admin_webapp = Webapp.find(params[:id])
  end

  # POST /admin/webapps
  # POST /admin/webapps.json
  def create
    @admin_webapp = Webapp.new(params[:admin_webapp])

    respond_to do |format|
      if @admin_webapp.save
        format.html { redirect_to @admin_webapp, notice: 'Webapp was successfully created.' }
        format.json { render json: @admin_webapp, status: :created, location: @admin_webapp }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_webapp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/webapps/1
  # PUT /admin/webapps/1.json
  def update
    @admin_webapp = Webapp.find(params[:id])

    respond_to do |format|
      if @admin_webapp.update_attributes(params[:admin_webapp])
        format.html { redirect_to @admin_webapp, notice: 'Webapp was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_webapp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/webapps/1
  # DELETE /admin/webapps/1.json
  def destroy
    @admin_webapp = Webapp.find(params[:id])
    @admin_webapp.destroy

    respond_to do |format|
      format.html { redirect_to admin_webapps_url }
      format.json { head :no_content }
    end
  end
end
