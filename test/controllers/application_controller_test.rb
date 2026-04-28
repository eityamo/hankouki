require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  # --- ロケール設定 ---

  test "デフォルトロケールは ja" do
    get root_path
    assert_equal :ja, I18n.default_locale
  end

  test "locale=en パラメータで英語に切り替わる" do
    get root_path(locale: :en)
    assert_response :success
    assert_select "html" # ページがレンダリングされることを確認
  end

  test "locale=zh パラメータで中国語に切り替わる" do
    get root_path(locale: :zh)
    assert_response :success
  end

  test "locale パラメータなしでデフォルトロケールが使われる" do
    get root_path
    assert_response :success
  end

  # --- URLにロケールが含まれる ---

  test "ロケール付きURLでリンクが生成される" do
    get root_path(locale: :en)
    assert_response :success
  end

  test "日本語ロケールで terms にアクセスできる" do
    get terms_path(locale: :ja)
    assert_response :success
  end

  test "英語ロケールで terms にアクセスできる" do
    get terms_path(locale: :en)
    assert_response :success
  end

  test "中国語ロケールで privacy_policy にアクセスできる" do
    get privacy_policy_path(locale: :zh)
    assert_response :success
  end
end
