class StaffsController < ApplicationController
  before_action :set_staff, only: [:show, :edit, :update, :destroy]
  before_action :set_staffs, only: [:new]

  # GET /staffs
  def index
    @staffs = Staff.all
  end

  # GET /staffs/1
  def show
  end

  # GET /staffs/new
  def new
    @staff = Staff.new
  end

  # GET /staffs/1/edit
  def edit
  end

  # POST /staffs
  def create
    @staff = Staff.new(staff_params)
    if @staff.save
      redirect_to new_staff_url, notice: 'Staff was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /staffs/1
  def update
    if @staff.update(staff_params)
      redirect_to @staff, notice: 'Staff was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /staffs/1
  def destroy
    @staff.destroy
    redirect_to new_staff_url, notice: 'Staff was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff
      @staff = Staff.find(params[:id])
    end

    def set_staffs
      @staffs = Staff.all
    end

    # Only allow a trusted parameter "white list" through.
    def staff_params
      params.require(:staff).permit(:name, :login, :mail, :hashed_password)
    end
end
