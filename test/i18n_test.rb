require "test_helper"

class I18nTest < ActiveSupport::TestCase
  def all_keys(hash, prefix = "")
    hash.each_with_object([]) do |(key, value), keys|
      full_key = prefix.empty? ? key.to_s : "#{prefix}.#{key}"
      if value.is_a?(Hash)
        keys.concat(all_keys(value, full_key))
      else
        keys << full_key
      end
    end
  end

  test "ja/en/zh の翻訳キーが一致する" do
    ja_keys = all_keys(I18n.backend.translations[:ja]).sort
    en_keys = all_keys(I18n.backend.translations[:en]).sort
    zh_keys = all_keys(I18n.backend.translations[:zh]).sort

    # rails-i18n gem が提供するキーを除外（各言語で異なる）
    rails_prefixes = %w[date time number datetime support errors activerecord helpers i18n]
    filter = ->(keys) { keys.reject { |k| rails_prefixes.any? { |p| k.start_with?(p) } } }

    ja_filtered = filter.call(ja_keys)
    en_filtered = filter.call(en_keys)
    zh_filtered = filter.call(zh_keys)

    missing_in_en = ja_filtered - en_filtered
    missing_in_zh = ja_filtered - zh_filtered
    extra_in_en = en_filtered - ja_filtered
    extra_in_zh = zh_filtered - ja_filtered

    assert missing_in_en.empty?, "en に不足しているキー: #{missing_in_en.join(', ')}"
    assert missing_in_zh.empty?, "zh に不足しているキー: #{missing_in_zh.join(', ')}"
    assert extra_in_en.empty?, "en に余分なキー: #{extra_in_en.join(', ')}"
    assert extra_in_zh.empty?, "zh に余分なキー: #{extra_in_zh.join(', ')}"
  end
end
