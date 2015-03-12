class IssuesController < ApplicationController
  
  skip_before_action :authorize, :only => [:new, :create, :public_show, :public_update]

  before_action :set_issue, only: [:public_show, :show, :edit, :update, :public_update, :destroy]
  before_filter :find_issues, :only => [:list]

  before_filter :check_for_default_issue_status, :only => [:create]
  before_filter :find_or_create_customer, :only => [:create]
  before_filter :find_department, :only => [:create]
  before_filter :build_new_issue_from_params, :only => [:create]

  before_action :check_if_status_changed, only: [:update]
  before_action :check_if_owner_changed, only: [:update]

  # GET /issues
  def index
    redirect_to manage_url
  end

  def list
    @unassigned_issues = @issues.select {|i| i.assigned_to.nil? }
    @open_issues = @issues.select {|i| i.open? }
    @onhold_issues = @issues.select {|i| i.status_id == IssueStatus::ON_HOLD_STATUS}
    @closed_issues = @issues.select {|i| i.closed? }
  end

  # GET /issues/1
  def show
  end
  
  def public_show
  end

  # GET /issues/new
  def new
    @issue = Issue.new(department: @department)
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  def create
    if @issue.save
      redirect_to :action => "public_show", :id => @issue.public_id, notice: 'Issue was successfully created.'
    else
      render :new
    end
  end

  def public_update
    if issue_params[:message]
      History.add_message @issue, @issue.author, issue_params[:message]
      redirect_to :action => "public_show", :id => @issue.public_id, notice: 'Issue was successfully updated.'
    else
      render :edit
    end
  end

  # PATCH/PUT /issues/1
  def update
    if @issue.update(issue_params)
      History.add_message @issue, @current_user, params[:message] unless params[:message].nil?
      redirect_to :action => "show", :id => @issue.public_id, notice: 'Issue was successfully updated.'
    else
      render :edit
    end
  end

  def take
    staff = @current_user
    issue = Issue.find_by( public_id: params[:id] )
    if staff && issue && staff.id != issue.assigned_to_id
      issue.assigned_to = staff
      redirect_to manage_path, notice: "Issue was successfully assigned to #{staff.name}." if issue.save!
    else
      redirect_to manage_path, notice: "You haven't take the issue"
    end
  end

  # DELETE /issues/1
  def destroy
    @issue.destroy
    redirect_to manage_url, notice: 'Issue was successfully destroyed.'
  end

  private
    
    def set_issue
      @issue = Issue.find_by public_id: params[:id]
    end

    def issue_params
      params.require(:issue).permit(:public_id, :subject, :status_id, :assigned_to_id, :department_id, :author_id, :message)
    end

    def build_new_issue_from_params
      if params[:id].blank?
        @issue = Issue.new
        @issue.public_id = @issue.generate_public_id
        @issue.subject = params[:issue][:subject]
        @issue.author = @customer
        @issue.status = @default_status
        @issue.department = @department
        @issue.description = params[:issue][:description]
      end
    end
    
    def find_or_create_customer
      if Customer.where(:mail => params[:issue][:customer_mail]).empty?
        customer = Customer.create(name: params[:issue][:customer_name], mail: params[:issue][:customer_mail])
      else 
        customer = Customer.where(mail: params[:issue][:customer_mail]).take
      end
      @customer = customer
    end
    
    def find_department 
      @department = Department.where(:id => params[:issue][:department_id]).take || Department.default
    end

    def check_for_default_issue_status
      if IssueStatus.default.nil?
        #render_error l(:no_default_issue_status)
        return false
      else 
        @default_status = IssueStatus.where(:is_default => true).take
        return true
      end
    end
   
    def check_if_status_changed
      current_status = @issue.status_id 
      new_status = issue_params[:status_id].to_i
      message = "Status was changed from '#{@issue.status.name}' to '#{IssueStatus.find(issue_params[:status_id]).name}'"
      History.add_message @issue, @current_user, message unless current_status == new_status
    end

    def check_if_owner_changed
      current_owner = @issue.assigned_to || Nobody.new
      new_owner = issue_params[:assigned_to_id].to_i
      message = "Owner was changed from '#{current_owner.name}' to '#{Staff.find(issue_params[:assigned_to_id]).name}'"
      History.add_message @issue, @current_user, message unless current_owner.id == new_owner
    end
end
