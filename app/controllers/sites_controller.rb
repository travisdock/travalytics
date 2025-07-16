class SitesController < ApplicationController
  before_action :require_authentication
  before_action :set_site, only: [:show, :edit, :update, :destroy]
  
  def index
    @sites = current_user.sites
  end
  
  def new
    @site = current_user.sites.build
  end
  
  def create
    @site = current_user.sites.build(site_params)
    
    if @site.save
      redirect_to @site, notice: 'Site created successfully'
    else
      render :new
    end
  end
  
  def show
    redirect_to dashboard_path(site_id: @site.id)
  end
  
  def edit
  end
  
  def update
    if @site.update(site_params)
      redirect_to @site, notice: 'Site updated successfully'
    else
      render :edit
    end
  end
  
  def destroy
    @site.destroy
    redirect_to sites_path, notice: 'Site deleted successfully'
  end
  
  private
  
  def set_site
    @site = current_user.sites.find(params[:id])
  end
  
  def site_params
    params.require(:site).permit(:name, :domain)
  end
end