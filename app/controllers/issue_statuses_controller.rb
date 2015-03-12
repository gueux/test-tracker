class IssueStatusesController < ApplicationController
  before_action :set_issue_status, only: [:update, :destroy]
  before_action :set_issue_statuses, only: [:new]

  # GET /issue_statuses
  def index
    @issue_statuses = IssueStatus.all
  end

  # GET /issue_statuses/1
  def show
  end

  # GET /issue_statuses/new
  def new
    @issue_status = IssueStatus.new
  end

  # GET /issue_statuses/1/edit
  def edit
  end

  # POST /issue_statuses
  def create
    @issue_status = IssueStatus.new(issue_status_params)
    if @issue_status.save
      redirect_to new_issue_status_path, notice: 'Issue status was successfully created.'
    else
      render :new
    end
  end

  # DELETE /issue_statuses/1
  def destroy
    @issue_status.destroy
    redirect_to new_issue_status_url, notice: 'Issue status was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue_status
      @issue_status = IssueStatus.find(params[:id])
    end

    def set_issue_statuses
      @issue_statuses = IssueStatus.all
    end

    # Only allow a trusted parameter "white list" through.
    def issue_status_params
      params.require(:issue_status).permit(:name, :is_closed)
    end
end
