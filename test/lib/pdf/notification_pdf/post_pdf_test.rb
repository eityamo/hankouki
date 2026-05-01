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

  # --- PDF生成の基本 ---

  test "render で有効な PDF バイナリが返る" do
    pdf = NotificationPdf::PostPdf.new(build_record)
    output = pdf.render
    assert output.start_with?("%PDF"), "PDF ヘッダーが見つかりません"
    assert output.length > 0
  end

  test "render の戻り値は String" do
    pdf = NotificationPdf::PostPdf.new(build_record)
    assert_instance_of String, pdf.render
  end

  # --- 印鑑のバリエーション ---

  test "stamp 1文字で PDF 生成成功" do
    pdf = NotificationPdf::PostPdf.new(build_record(stamp: "山"))
    assert pdf.render.start_with?("%PDF")
  end

  test "stamp 2文字で PDF 生成成功" do
    pdf = NotificationPdf::PostPdf.new(build_record(stamp: "山田"))
    assert pdf.render.start_with?("%PDF")
  end

  test "stamp 3文字で PDF 生成成功" do
    pdf = NotificationPdf::PostPdf.new(build_record(stamp: "山田太"))
    assert pdf.render.start_with?("%PDF")
  end

  test "stamp 4文字で PDF 生成成功（vertical_stamp 適用後）" do
    record = build_record(stamp: "ABCD")
    record.valid? # vertical_stamp コールバック発火
    pdf = NotificationPdf::PostPdf.new(record)
    assert pdf.render.start_with?("%PDF")
  end

  test "stamp 空文字で PDF 生成成功（指紋画像使用）" do
    pdf = NotificationPdf::PostPdf.new(build_record(stamp: ""))
    assert pdf.render.start_with?("%PDF")
  end

  # --- getup / cleanup のバリエーション ---

  test "getup が 'necessary' で PDF 生成成功" do
    pdf = NotificationPdf::PostPdf.new(build_record(getup: "necessary"))
    assert pdf.render.start_with?("%PDF")
  end

  test "getup が 'unnecessary' で PDF 生成成功" do
    pdf = NotificationPdf::PostPdf.new(build_record(getup: "unnecessary"))
    assert pdf.render.start_with?("%PDF")
  end

  test "getup が 'consultation' で PDF 生成成功" do
    pdf = NotificationPdf::PostPdf.new(build_record(getup: "consultation"))
    assert pdf.render.start_with?("%PDF")
  end

  test "cleanup が 'necessary' で PDF 生成成功" do
    pdf = NotificationPdf::PostPdf.new(build_record(cleanup: "necessary"))
    assert pdf.render.start_with?("%PDF")
  end

  test "cleanup が 'unnecessary' で PDF 生成成功" do
    pdf = NotificationPdf::PostPdf.new(build_record(cleanup: "unnecessary"))
    assert pdf.render.start_with?("%PDF")
  end

  test "cleanup が 'consultation' で PDF 生成成功" do
    pdf = NotificationPdf::PostPdf.new(build_record(cleanup: "consultation"))
    assert pdf.render.start_with?("%PDF")
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
