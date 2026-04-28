require "test_helper"

class RoutingTest < ActionDispatch::IntegrationTest
  # --- ロケールなし ---

  test "/ は records#new にルーティングされる" do
    assert_routing "/", controller: "records", action: "new"
  end

  test "GET /records は records#new に解決される" do
    assert_recognizes({ controller: "records", action: "new" }, "/records")
  end

  test "POST /records は records#create にルーティングされる" do
    assert_routing({ method: :post, path: "/records" }, controller: "records", action: "create")
  end

  test "/terms は records#terms にルーティングされる" do
    assert_routing "/terms", controller: "records", action: "terms"
  end

  test "/privacy_policy は records#privacy_policy にルーティングされる" do
    assert_routing "/privacy_policy", controller: "records", action: "privacy_policy"
  end

  # --- ロケール付き ---

  test "/ja は records#new にルーティングされる" do
    assert_routing "/ja", controller: "records", action: "new", locale: "ja"
  end

  test "/en は records#new にルーティングされる" do
    assert_routing "/en", controller: "records", action: "new", locale: "en"
  end

  test "/zh は records#new にルーティングされる" do
    assert_routing "/zh", controller: "records", action: "new", locale: "zh"
  end

  test "/ja/terms は records#terms にルーティングされる" do
    assert_routing "/ja/terms", controller: "records", action: "terms", locale: "ja"
  end

  # --- 不正なロケール ---

  test "不正なロケール /xx は 404 になる" do
    assert_raises(ActionController::RoutingError) do
      get "/xx"
    end
  end
end
