require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should get not_found" do
    get "/404"
    assert_response :not_found
    assert_select "h1", "404"
  end

  test "should get internal_server_error" do
    get "/500"
    assert_response :internal_server_error
    assert_select "h1", "500"
  end

  test "not_found page shows localized content in Japanese" do
    get "/404", params: { locale: :ja }
    assert_response :not_found
    assert_select "h2", I18n.t('defaults.error_404_title', locale: :ja)
  end

  test "not_found page shows localized content in English" do
    get "/404", params: { locale: :en }
    assert_response :not_found
    assert_select "h2", I18n.t('defaults.error_404_title', locale: :en)
  end

  test "not_found page shows localized content in Chinese" do
    get "/404", params: { locale: :zh }
    assert_response :not_found
    assert_select "h2", I18n.t('defaults.error_404_title', locale: :zh)
  end
end
