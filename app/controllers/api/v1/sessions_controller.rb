class Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    warden.authenticate!(:scope => resource_name, :store => false, :recall => "#{controller_path}#failure")
    @colors = current_user.colors.all
    render :status => 200,
           :json => { :success => true,
                      :info => t("devise.sessions.signed_in"),
                      :data => { :auth_token => current_user.authentication_token, :email => current_user.email, :color => @colors } }
  end

  def destroy
    warden.authenticate!(:scope => resource_name, :store => false, :recall => "#{controller_path}#failure")
    current_user.reset_authentication_token!
    render :status => 200,
           :json => { :success => true,
                      :info => t("devise.sessions.signed_out"),
                      :data => {} }
  end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
  end
end
