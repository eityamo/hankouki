require "test_helper"

class NotificationPdf::PostPdfTest < ActiveSupport::TestCase
  def build_record(overrides = {})
    RecordsForm.new({
      myname: "太郎",
      stamp: "山田",
      old: 12,
      fromdate: Date.new(2026, 4, 1),
      todate: Date.new(2026, 4, 30),
      yourname: "お母さん",
      getup: "necessary",
      cleanup: "unnecessary",
      remark: "よろしく"
    }.merge(overrides))
  end

  # クラスレベルでキャッシュし、フォント読み込みの繰り返しを回避
  def self.standard_pdf_output
    @standard_pdf_output ||= begin
      record = RecordsForm.new(
        myname: "太郎", stamp: "山田", old: 12,
        fromdate: Date.new(2026, 4, 1), todate: Date.new(2026, 4, 30),
        yourname: "お母さん", getup: "necessary", cleanup: "unnecessary",
        remark: "よろしく"
      )
      NotificationPdf::PostPdf.new(record).render
    end
  end

  # --- PDF生成の基本 ---

  test "render で有効な PDF バイナリが返る" do
    output = self.class.standard_pdf_output
    assert output.start_with?("%PDF"), "PDF ヘッダーが見つかりません"
    assert output.length > 0
  end

  test "render の戻り値は String" do
    assert_instance_of String, self.class.standard_pdf_output
  end

  # --- 印鑑のバリエーション ---

  test "stamp 各文字数で PDF 生成成功" do
    [
      ["山", "1文字"],
      ["山田", "2文字"],
      ["山田太", "3文字"],
      ["", "空文字（指紋画像使用）"],
    ].each do |stamp_value, label|
      pdf = NotificationPdf::PostPdf.new(build_record(stamp: stamp_value))
      assert pdf.render.start_with?("%PDF"), "stamp #{label}で失敗"
    end
  end

  test "stamp 4文字で PDF 生成成功（vertical_stamp 適用後）" do
    record = build_record(stamp: "ABCD")
    record.valid? # vertical_stamp コールバック発火
    pdf = NotificationPdf::PostPdf.new(record)
    assert pdf.render.start_with?("%PDF")
  end

  # --- getup / cleanup のバリエーション ---

  test "getup の全選択肢で PDF 生成成功" do
    %w[necessary unnecessary consultation].each do |value|
      pdf = NotificationPdf::PostPdf.new(build_record(getup: value))
      assert pdf.render.start_with?("%PDF"), "getup=#{value} で失敗"
    end
  end

  test "cleanup の全選択肢で PDF 生成成功" do
    %w[necessary unnecessary consultation].each do |value|
      pdf = NotificationPdf::PostPdf.new(build_record(cleanup: value))
      assert pdf.render.start_with?("%PDF"), "cleanup=#{value} で失敗"
    end
  end

  # --- 多言語 ---

  test "英語ロケールで PDF 生成成功" do
    I18n.with_locale(:en) do
      pdf = NotificationPdf::PostPdf.new(build_record)
      assert pdf.render.start_with?("%PDF")
    end
  end

  test "中国語ロケールで PDF 生成成功" do
    I18n.with_locale(:zh) do
      pdf = NotificationPdf::PostPdf.new(build_record)
      assert pdf.render.start_with?("%PDF")
    end
  end

  # --- 備考の長文 ---

  test "remark が長文でも PDF 生成成功" do
    pdf = NotificationPdf::PostPdf.new(build_record(remark: "あ" * 131))
    assert pdf.render.start_with?("%PDF")
  end
end
