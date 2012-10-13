class RolesController < ApplicationController

  before_filter :authenticate_user!

  def edit
    @user = current_user
    render 'edit'
  end

  def show
    redirect_to current_user.locum? ? profile_locum_path : profile_store_path
  end

  def update
    @user = current_user
    @user.attributes = request[:users]

    if @user.save
      flash[:notice] = "Success"
      redirect_to root_path
    else
      flash[:alert] = "Unsuccessful"
      render 'new'
    end
  end

end

