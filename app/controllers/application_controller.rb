class ApplicationController < ActionController::Base

  before_action :authorize

  def render_error(arg)
    arg = {:message => arg} unless arg.is_a?(Hash)

    @message = arg[:message]
    @message = l(@message) if @message.is_a?(Symbol)
    @status = arg[:status] || 500

    respond_to do |format|
      format.html {
        render :template => 'common/error', :layout => use_layout, :status => @status
      }
      format.any { head @status }
    end
  end

  def use_layout
    request.xhr? ? false : 'base'
  end
  
  def find_issue
    @issue = Issue.find_by public_id: params[:id]
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_issues
    @issues = Issue.all.preload(:department, :status, :author, :assigned_to).to_a
    raise ActiveRecord::RecordNotFound if @issues.empty?
  rescue ActiveRecord::RecordNotFound
    render_404
  end  

  def render_404(options={})
    render_error({:message => :notice_file_not_found, :status => 404}.merge(options))
    return false
  end

  protected

    def authorize
      current_user = Staff.find(session[:current_user]) if session[:current_user]
      unless current_user
        redirect_to login_url, notice: "Please log in"
      else 
        @current_user = current_user
      end
      
    end
end
