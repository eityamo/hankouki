require "test_helper"

class RecordsControllerTest < ActionDispatch::IntegrationTest
  # --- new アクション ---

  test "GET / でフォームページが表示される" do
    get root_path
    assert_response :success
  end

  test "GET /records でフォームページが表示される" do
    get records_path
    assert_response :success
  end

  test "フォームページにフォーム要素が含まれる" do
    get root_path
    assert_select "form"
    assert_select "input[name='records_form[myname]']"
    assert_select "input[name='records_form[stamp]']"
    assert_select "input[name='records_form[old]']"
  end

  # --- create アクション（正常系）---

  test "POST /records で有効なパラメータを送信するとPDFが返る" do
    post records_path, params: {
      records_form: {
        myname: "太���",
        stamp: "山田",
        old: 12,
        fromdate: "2026-04-01",
        todate: "2026-04-30",
        yourname: "お母さん",
        getup: "necessary",
        cleanup: "unnecessary",
        remark: "よろしく"
      }
    }
    assert_response :success
    assert_equal "application/pdf", response.content_type
  end

  # --- create アクション（バリデーションエラー）---

  test "POST /records でバリデーションエラー時はフォームを再表示" do
    post records_path, params: {
      records_form: {
        myname: "あ" * 11,
        stamp: "",
        old: 12,
        fromdate: "2026-04-10",
        todate: "2026-04-01",
        yourname: "",
        getup: "",
        cleanup: "",
        remark: ""
      }
    }
    assert_response :success
    assert_select "form"
  end

  # --- terms アクション ---

  test "GET /terms で利用規約ページが表示される" do
    get terms_path
    assert_response :success
  end

  # --- privacy_policy アクション ---

  test "GET /privacy_policy でプライバシーポリシーページが表示される" do
    get privacy_policy_path
    assert_response :success
  end

  # --- ロケール付きアクセス ---

  test "GET /ja でフォームページが表示される" do
    get root_path(locale: :ja)
    assert_response :success
  end

  test "GET /en でフォームページが表示される" do
    get root_path(locale: :en)
    assert_response :success
  end

  test "GET /zh でフォームページが表示される" do
    get root_path(locale: :zh)
    assert_response :success
  end
end
