class ManagesController < ApplicationController
  before_action :set_manage, only: [:show, :edit, :update, :destroy]

  # GET /manages
  def index
    @manages = Manage.all
  end

  # GET /manages/1
  def show
  end

  # GET /manages/new
  def new
    @manage = Manage.new
  end

  # GET /manages/1/edit
  def edit
  end

  # POST /manages
  def create
    @manage = Manage.new(manage_params)

    if @manage.save
      redirect_to @manage, notice: 'Manage was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /manages/1
  def update
    if @manage.update(manage_params)
      redirect_to @manage, notice: 'Manage was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /manages/1
  def destroy
    @manage.destroy
    redirect_to manages_url, notice: 'Manage was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage
      @manage = Manage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def manage_params
      params.require(:manage).permit(:index)
    end
end
