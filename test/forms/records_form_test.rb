require "test_helper"

class RecordsFormTest < ActiveSupport::TestCase
  def valid_params
    {
      myname: "太郎",
      stamp: "山田",
      old: 12,
      fromdate: Date.new(2026, 4, 1),
      todate: Date.new(2026, 4, 30),
      yourname: "お母さん",
      remark: "よろしく",
      getup: "necessary",
      cleanup: "unnecessary"
    }
  end

  # --- 正常系 ---

  test "有効なパラメータでバリデーション通過" do
    form = RecordsForm.new(valid_params)
    assert form.valid?
  end

  test "stamp が nil の場合でもエラーなくバリデーションが通る" do
    form = RecordsForm.new(fromdate: Date.today, todate: Date.today + 1, stamp: nil)
    assert_nothing_raised { form.valid? }
  end

  # --- myname バリデーション ---

  test "myname が10文字ちょうどは有効" do
    form = RecordsForm.new(valid_params.merge(myname: "あ" * 10))
    assert form.valid?
  end

  test "myname が11文字で無効" do
    form = RecordsForm.new(valid_params.merge(myname: "あ" * 11))
    assert_not form.valid?
    assert form.errors[:myname].any?
  end

  # --- stamp バリデーション ---

  test "stamp が4文字ちょうどは有効" do
    form = RecordsForm.new(valid_params.merge(stamp: "山田太郎"))
    assert form.valid?
  end

  test "stamp が5文字で無効" do
    form = RecordsForm.new(valid_params.merge(stamp: "山田太郎君"))
    assert_not form.valid?
    assert form.errors[:stamp].any?
  end

  # --- yourname バリデーション ---

  test "yourname が10文字ちょうどは有効" do
    form = RecordsForm.new(valid_params.merge(yourname: "あ" * 10))
    assert form.valid?
  end

  test "yourname が11文字で無効" do
    form = RecordsForm.new(valid_params.merge(yourname: "あ" * 11))
    assert_not form.valid?
    assert form.errors[:yourname].any?
  end

  # --- old バリデーション ---

  test "old が1は有効" do
    form = RecordsForm.new(valid_params.merge(old: 1))
    assert form.valid?
  end

  test "old が99は有効" do
    form = RecordsForm.new(valid_params.merge(old: 99))
    assert form.valid?
  end

  test "old が0で無効" do
    form = RecordsForm.new(valid_params.merge(old: 0))
    assert_not form.valid?
    assert form.errors[:old].any?
  end

  test "old が100で無効" do
    form = RecordsForm.new(valid_params.merge(old: 100))
    assert_not form.valid?
    assert form.errors[:old].any?
  end

  test "old が負数で無効" do
    form = RecordsForm.new(valid_params.merge(old: -1))
    assert_not form.valid?
    assert form.errors[:old].any?
  end

  test "old が nil は許容される" do
    form = RecordsForm.new(valid_params.merge(old: nil))
    assert form.valid?
  end

  # --- remark バリデーション ---

  test "remark が131文字ちょうどは有効" do
    form = RecordsForm.new(valid_params.merge(remark: "あ" * 131))
    assert form.valid?
  end

  test "remark が132文字で無効" do
    form = RecordsForm.new(valid_params.merge(remark: "あ" * 132))
    assert_not form.valid?
    assert form.errors[:remark].any?
  end

  # --- 日付バリデーション ---

  test "todate が fromdate より後なら有効" do
    form = RecordsForm.new(valid_params.merge(fromdate: Date.new(2026, 4, 1), todate: Date.new(2026, 4, 2)))
    assert form.valid?
  end

  test "todate が fromdate と同日で無効" do
    form = RecordsForm.new(valid_params.merge(fromdate: Date.new(2026, 4, 1), todate: Date.new(2026, 4, 1)))
    assert_not form.valid?
    assert form.errors[:todate].any?
  end

  test "todate が fromdate より前で無効" do
    form = RecordsForm.new(valid_params.merge(fromdate: Date.new(2026, 4, 10), todate: Date.new(2026, 4, 1)))
    assert_not form.valid?
    assert form.errors[:todate].any?
  end

  # --- vertical_stamp コールバック ---

  test "stamp が4文字の場合 vertical_stamp で並び替えられる" do
    form = RecordsForm.new(valid_params.merge(stamp: "ABCD"))
    form.valid?
    # vertical: part[2]+part[0]+part[3]+part[1] => "CADB"
    assert_equal "CADB", form.stamp
  end

  test "stamp が3文字の場合は並び替えされない" do
    form = RecordsForm.new(valid_params.merge(stamp: "ABC"))
    form.valid?
    assert_equal "ABC", form.stamp
  end

  test "stamp が空文字の場合はエラーにならない" do
    form = RecordsForm.new(valid_params.merge(stamp: ""))
    assert form.valid?
  end

  # --- サニタイズ ---

  test "myname に含まれる < > がエスケープされる" do
    form = RecordsForm.new(valid_params.merge(myname: "<b>太郎</b>"))
    form.valid?
    assert_equal "&lt;b&gt;太郎&lt;/b&gt;", form.myname
  end

  test "remark に含まれる < > がエスケープされる" do
    form = RecordsForm.new(valid_params.merge(remark: "<script>"))
    form.valid?
    assert_equal "&lt;script&gt;", form.remark
  end

  test "yourname に含まれる < > がエスケープされる" do
    form = RecordsForm.new(valid_params.merge(yourname: "お母<さん>"))
    form.valid?
    assert_equal "お母&lt;さん&gt;", form.yourname
  end

  test "stamp に含まれる < > がエスケープされる" do
    form = RecordsForm.new(valid_params.merge(stamp: "<山>"))
    form.valid?
    assert_equal "&lt;山&gt;", form.stamp
  end

  test "タグを含まない入力値はそのまま保持される" do
    form = RecordsForm.new(valid_params)
    form.valid?
    assert_equal "太郎", form.myname
    assert_equal "よろしく", form.remark
  end

  # --- デフォルト値 ---

  test "fromdate のデフォルトは今日" do
    form = RecordsForm.new
    assert_equal Date.today, form.fromdate.to_date
  end

  test "todate のデフォルトは明日" do
    form = RecordsForm.new
    assert_equal Date.today + 1, form.todate.to_date
  end

  # --- 属性の型 ---

  test "old は integer として扱われる" do
    form = RecordsForm.new(valid_params.merge(old: "12"))
    assert_equal 12, form.old
  end
end
