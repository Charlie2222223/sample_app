class SessionsController < ApplicationController

  def new
  end

  # app/controllers/sessions_controller.rb (イメージ)

def create
  user = User.find_by(email: params[:session][:email].downcase)
  if user && user.authenticate(params[:session][:password])
    if user.activated?
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user # ← 1回目のリダイレクト
    else
      message  = "Account not activated. "
      message += "Check your email for the activation link."
      flash[:warning] = message
      redirect_to root_url # ← 条件によってはここでもリダイレクト命令が出る！
    end
    # ここで redirect_to などの命令が漏れて残っていませんか？
  else
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new'
  end
end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

end
