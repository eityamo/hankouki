module NotificationPdf
  class PostPdf < Prawn::Document
    FONT_DIR = Rails.root.join('app', 'assets', 'fonts').to_s

    # レイアウト座標定数
    TITLE_Y       = 700
    DATE_X        = 350
    DATE_Y        = 640
    HEADER_X      = 75
    HEADER_Y      = 620
    LABEL_X       = 70
    VALUE_CENTER_X = 0
    NAME_Y        = 550
    SEAL_X        = 350
    AGE_X         = 385
    AGE_VALUE_X   = 391
    PERIOD_Y      = 490
    PERIOD_END_Y  = 460
    PERIOD_VALUE_X = 200
    PARENT_Y      = 400
    GETUP_Y       = 320
    CLEANUP_Y     = 270
    REMARK_LABEL_Y = 160
    REMARK_BOX_X  = 115
    REMARK_BOX_Y  = 148
    REMARK_BOX_W  = 312
    REMARK_BOX_H  = 100
    FOOTER_Y1     = 70
    FOOTER_Y2     = 60
    STAMP_AT      = [330, 530]

    # 選択肢の丸印位置（X 座標）
    OPTION_NECESSARY_X    = 217
    OPTION_UNNECESSARY_X  = 294
    OPTION_CONSULTATION_X = 380
    CIRCLE_RADIUS = 10

    # 選択肢ラベル位置
    OPTION_LABEL_NECESSARY    = { at: [190, 0], width: 54 }.freeze
    OPTION_LABEL_UNNECESSARY  = { at: [260, 0], width: 68 }.freeze
    OPTION_LABEL_CONSULTATION = { at: [345, 0], width: 69 }.freeze

    def initialize(record)
      super(page_size: "A4")

      register_fonts

      create_title
      create_header
      create_contents
      create_form(record)
      create_stamps(record)
      create_footer
    end

    private

    def register_fonts
      font_families.update(
        "SourceHanSans" => {
          bold: "#{FONT_DIR}/SourceHanSans-Bold.ttc",
          normal: "#{FONT_DIR}/SourceHanSans-Light.ttc",
        },
        "SourceHanSansHeavy" => {
          normal: "#{FONT_DIR}/SourceHanSans-Heavy.ttc",
        },
        "YujiSyuku" => {
          normal: "#{FONT_DIR}/YujiSyuku-Regular.ttf",
        }
      )
    end

    def create_title
      font "SourceHanSansHeavy" do
        text_box I18n.t('defaults.site'), at: [0, TITLE_Y], width: bounds.width, align: :center, size: 40, overflow: :shrink_to_fit
      end
    end

    def create_header
      font "SourceHanSans", style: :bold do
        text_box I18n.l(Date.current, format: :long), at: [DATE_X, DATE_Y], width: bounds.width - DATE_X
        text_box I18n.t('records.new.create_header'), at: [HEADER_X, HEADER_Y], width: bounds.width - HEADER_X * 2, overflow: :shrink_to_fit
      end
    end

    # ラベル列の最大幅（英語ラベルがはみ出さないよう制限）
    LABEL_WIDTH = 120

    def create_contents
      font "SourceHanSans", style: :bold do
        text_box I18n.t('activemodel.attributes.records_form.myname'), at: [LABEL_X, NAME_Y], width: LABEL_WIDTH, overflow: :shrink_to_fit
        text_box I18n.t('records.new.seal'), at: [SEAL_X, NAME_Y], width: 40
        text_box "(      )" + I18n.t('records.new.age'), at: [AGE_X, NAME_Y], width: 100
        text_box I18n.t('activemodel.attributes.records_form.fromdate'), at: [LABEL_X, PERIOD_Y], width: LABEL_WIDTH, overflow: :shrink_to_fit
        text_box I18n.t('records.new.from'), at: [DATE_X, PERIOD_Y], width: 60
        text_box I18n.t('records.new.to'), at: [DATE_X, PERIOD_END_Y], width: 60
        text_box I18n.t('activemodel.attributes.records_form.yourname'), at: [LABEL_X, PARENT_Y], width: LABEL_WIDTH, overflow: :shrink_to_fit
        text_box I18n.t('activemodel.attributes.records_form.getup'), at: [LABEL_X, GETUP_Y], width: LABEL_WIDTH, overflow: :shrink_to_fit
        text_box I18n.t('activemodel.attributes.records_form.cleanup'), at: [LABEL_X, CLEANUP_Y], width: LABEL_WIDTH, overflow: :shrink_to_fit
        text_box I18n.t('activemodel.attributes.records_form.remark'), at: [LABEL_X, REMARK_LABEL_Y], width: LABEL_WIDTH, overflow: :shrink_to_fit
        font "SourceHanSans" do
          [GETUP_Y, CLEANUP_Y].each do |y|
            draw_option_label(I18n.t('records.new.necessary'), OPTION_LABEL_NECESSARY, y)
            draw_option_label(I18n.t('records.new.unnecessary'), OPTION_LABEL_UNNECESSARY, y)
            draw_option_label(I18n.t('records.new.consultation'), OPTION_LABEL_CONSULTATION, y)
          end
        end
      end
    end

    def draw_option_label(text, config, y)
      text_box text, at: [config[:at][0], y], width: config[:width], align: :center, overflow: :shrink_to_fit
    end

    def create_form(record)
      font "SourceHanSans" do
        text_box record.myname.to_s, at: [VALUE_CENTER_X, NAME_Y], align: :center
        text_box record.old.to_s, at: [AGE_VALUE_X, NAME_Y]
        text_box I18n.l(record.fromdate, format: :long), at: [PERIOD_VALUE_X, PERIOD_Y]
        text_box I18n.l(record.todate, format: :long), at: [PERIOD_VALUE_X, PERIOD_END_Y]
        text_box record.yourname.to_s, at: [VALUE_CENTER_X, PARENT_Y], align: :center
        draw_selection_circle(record.getup, GETUP_Y - 7)
        draw_selection_circle(record.cleanup, CLEANUP_Y - 7)
        bounding_box([REMARK_BOX_X, REMARK_BOX_Y], width: REMARK_BOX_W, height: REMARK_BOX_H) do
          text_box record.remark.to_s
        end
      end
    end

    def draw_selection_circle(value, y)
      case value
      when 'necessary'
        stroke_circle [OPTION_NECESSARY_X, y], CIRCLE_RADIUS
      when 'unnecessary'
        stroke_ellipse [OPTION_UNNECESSARY_X, y], CIRCLE_RADIUS
      when 'consultation'
        stroke_ellipse [OPTION_CONSULTATION_X, y], CIRCLE_RADIUS
      end
    end

    def create_stamps(record)
      create_stamp('approved') do
        font('YujiSyuku') do
          stroke_color 'ce3337'
          fill_color 'ce3337'
          if record.stamp.length == 1
            stroke_circle [16, 16], 13
            bounding_box([3, 29], width: 26, height: 26) do
              text_box record.stamp.to_s, at: [4, 23], size: 18, overflow: :shrink_to_fit
            end
          elsif record.stamp.length == 2
            stroke_circle [16, 16], 16
            bounding_box([8, 32], width: 16, height: 32) do
              text_box record.stamp.to_s, at: [0, 32], size: 16, overflow: :shrink_to_fit
            end
          elsif record.stamp.length == 3
            stroke_ellipse [12, 14], 12, 20
            bounding_box([6, 31], width: 12, height: 36) do
              text_box record.stamp.to_s, at: [0, 37], size: 12, overflow: :shrink_to_fit
            end
          elsif record.stamp.length == 4
            stroke do
              rounded_rectangle [2, 45], 30, 30, 3
            end
            bounding_box([4, 35], width: 30, height: 30) do
              text_box record.stamp.to_s, at: [1, 37], size: 13, overflow: :shrink_to_fit
            end
          else
            image Rails.root.join('app', 'assets', 'images', 'fingerprint.jpg').to_s, at: [10, 30], width: 20, height: 30
          end
        end
      end
      stamp_at 'approved', STAMP_AT
    end

    def create_footer
      font "SourceHanSans", style: :bold do
        text_box I18n.t('records.new.create_footer1'), at: [LABEL_X, FOOTER_Y1], size: 10, width: bounds.width - LABEL_X * 2, overflow: :shrink_to_fit
        text_box I18n.t('records.new.create_footer2'), at: [LABEL_X, FOOTER_Y2], size: 10, width: bounds.width - LABEL_X * 2, overflow: :shrink_to_fit
      end
    end
  end
end
