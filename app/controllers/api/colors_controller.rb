class Api::ColorsController < ApplicationController
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # http_basic_authenticate_with :name => "myfinance", :password => "credit123"

  skip_before_filter :authenticate_user! # we do not need devise authentication here
  before_filter :fetch_user, :except => [:index, :destroy]

  def fetch_user
    @user = User.where(authentication_token: params[:auth_token]).first
  end

  def index
    @colors = Color.all

    respond_to do |format|
      format.json { render json: @colors }
    end
  end

  def show
    @color = @user.colors.all

    respond_to do |format|
      format.json { render json: { success: true, info: "Got", data: @color } }
    end
  end

  def create

    @color = Color.new
    @color.user_id = @user.id
    @color.hex = params[:color][:hex]


    respond_to do |format|
      if @color.save
        format.json { render json: { success: true, info: "Saved", data: @color }, status: :created }
      else
        format.json { render json: @color.errors, status: :unprocessable_entity }
      end
    end

  end
  #
  # def update
  #   respond_to do |format|
  #     if @user.update_attributes(params[:user])
  #       format.json { head :no_content, status: :ok }
  #       format.xml { head :no_content, status: :ok }
  #     else
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #       format.xml { render xml: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  #
  def destroy

    @color = Color.find(params[:color][:id])

    respond_to do |format|
      if @color.destroy
        format.json { render json: { success: true, info: "Deleted" } }
      else
        format.json { render json: @color.errors, status: :unprocessable_entity }
      end
    end
  end
end