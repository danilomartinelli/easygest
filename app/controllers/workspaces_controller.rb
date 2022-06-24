class WorkspacesController < ApplicationController
  before_action :authenticate_user!

  def create
    @workspace = Workspace.new(workspace_params)

    @workspace.nickname = Haiku.next {|nickname| Workspace.where(nickname: nickname).exists? }

    if @workspace.save
      @account = Account.new(user: current_user, workspace: @workspace)
      @account.save!

      redirect_to dashboard_view_path, notice: "Workspace criado com sucesso!"
    else
      render "dashboard/first_access", status: :unprocessable_entity
    end
  end

  private

  def workspace_params
    params.require(:workspace).permit(:name)
  end
end
