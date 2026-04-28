require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "full_title: ページタイトルが空なら base_title のみ" do
    I18n.locale = :ja
    assert_equal I18n.t("defaults.title"), full_title("")
  end

  test "full_title: ��ージタイトルがあれば 'ページタイトル | base_title'" do
    I18n.locale = :ja
    result = full_title("テスト")
    assert_equal "テスト | #{I18n.t('defaults.title')}", result
  end

  test "full_title: 英語ロケールでも動作する" do
    I18n.locale = :en
    result = full_title("Test")
    assert_equal "Test | #{I18n.t('defaults.title')}", result
  end

  test "full_title: 引数なしなら base_title のみ" do
    I18n.locale = :ja
    assert_equal I18n.t("defaults.title"), full_title
  end
end
