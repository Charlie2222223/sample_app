require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # [ログイン保持]のテスト
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    # クッキーが空でないことを確認
    assert_not cookies[:remember_token].blank?
  end

  # [ログイン保持なし]のテスト
  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    # クッキーを削除してログインし直す
    log_in_as(@user, remember_me: '0')
    # クッキーが空になったことを確認
    assert cookies[:remember_token].blank?
  end
end

# 有効なログイン情報を扱うテストの「ベース」クラス
class ValidLogin < UsersLoginTest
  def setup
    super
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
  end
end

# ログイン成功後の挙動を確認するテスト
class ValidLoginTest < ValidLogin
  test "valid login" do
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end

# ログアウト状態を前提とするテスト
class Logout < ValidLogin
  def setup
    super
    delete logout_path
  end
end

class LogoutTest < Logout
  # 正常なログアウト
  test "successful logout" do
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
  end

  # 【重要】2番目のウィンドウ（タブ）でログアウトしてもエラーにならないか
  test "should still work after logout in second window" do
    delete logout_path
    assert_redirected_to root_url
  end

  # ログアウト後のリンク表示の確認
  test "redirect after logout" do
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end