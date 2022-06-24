class DashboardController < ApplicationController
  before_action :authenticate_user!

  before_action :first_access!, only: [:index]

  layout "dashboard"

  def index; end;

  def first_access
    @workspace = Workspace.new

    render layout: "application"
  end

  private

  def first_access!
    if current_user.accounts.empty?
      redirect_to :welcome_view
    end
  end
end
