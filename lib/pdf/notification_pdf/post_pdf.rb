module NotificationPdf
  class PostPdf < Prawn::Document
    def initialize(record)
      # 新規PDF作成
      super(page_size: "A4")
      # 座標を表示
      # stroke_axis

      create_title
      create_header
      create_contents
      create_form(record)
      create_stamps(record)
      create_footer
    end

    def create_title
      font "app/assets/fonts/SourceHanSans-Heavy.ttc" do
        text_box I18n.t('defaults.site'), at: [0, 700], align: :center, size: 40
      end
    end

    def create_header
      font "app/assets/fonts/SourceHanSans-Bold.ttc" do
        text_box I18n.l(Date.current, format: :long), at: [350, 640]
        text_box I18n.t('records.new.create_header'), at: [75, 620]
      end
    end

    def create_contents
      font "app/assets/fonts/SourceHanSans-Bold.ttc" do
        text_box I18n.t('activemodel.attributes.records_form.myname'), at: [70, 550]
        text_box I18n.t('records.new.seal'), at: [350, 550]
        text_box "(      )" + I18n.t('records.new.age'), at: [385, 550]
        text_box I18n.t('activemodel.attributes.records_form.fromdate'), at: [70, 490]
        text_box I18n.t('records.new.from'), at: [350, 490]
        text_box I18n.t('records.new.to'), at: [350, 460]
        text_box I18n.t('activemodel.attributes.records_form.yourname'), at: [70, 400]
        text_box I18n.t('activemodel.attributes.records_form.getup'), at: [70, 320]
        text_box I18n.t('activemodel.attributes.records_form.cleanup'), at: [70, 270]
        text_box I18n.t('activemodel.attributes.records_form.remark'), at: [70, 160]
        font "app/assets/fonts/SourceHanSans-Light.ttc" do
          text_box I18n.t('records.new.necessary'), at: [190, 320], width: 54, align: :center
          text_box I18n.t('records.new.unnecessary'), at: [260, 320], width: 68, align: :center
          text_box I18n.t('records.new.consultation'), at: [345, 320], width: 69, align: :center
          text_box I18n.t('records.new.necessary'), at: [190, 270], width: 54, align: :center
          text_box I18n.t('records.new.unnecessary'), at: [260, 270], width: 68, align: :center
          text_box I18n.t('records.new.consultation'), at: [345, 270], width: 69, align: :center
        end
      end
    end

    def create_form(record)
      font "app/assets/fonts/SourceHanSans-Light.ttc" do
      text_box "#{record.myname}", at: [0, 550], align: :center
        text_box "#{record.old}", at: [391, 550]
        text_box "#{I18n.l(record.fromdate, format: :long)}", at: [200, 490]
        text_box "#{I18n.l(record.todate, format: :long)}", at: [200, 460]
        text_box "#{record.yourname}", at: [0, 400], align: :center
        if record.getup == I18n.t('records.new.necessary')
          stroke_circle [217, 313], 10
        elsif record.getup == I18n.t('records.new.unnecessary')
          stroke_ellipse [294, 313], 10
        elsif record.getup == I18n.t('records.new.consultation')
          stroke_ellipse [380, 313], 10
        end
        if record.cleanup == I18n.t('records.new.necessary')
          stroke_circle [217, 263], 10
        elsif record.cleanup == I18n.t('records.new.unnecessary')
          stroke_ellipse [294, 263], 10
        elsif record.cleanup == I18n.t('records.new.consultation')
          stroke_ellipse [380, 263], 10
        end
        bounding_box([115, 148], width: 312, height: 60) do
          text_box "#{record.remark}"
        end
      end
    end

    def create_stamps(record)
      create_stamp('approved') do
        font('app/assets/fonts/YujiSyuku-Regular.ttf') do
          stroke_color 'ce3337'
          fill_color 'ce3337'
          if record.stamp.length == 1
            stroke_circle [16, 16], 13
            bounding_box([3, 29], width: 26, height: 26) do
              text_box "#{record.stamp}", at: [4, 23], size: 18
            end
          elsif record.stamp.length == 2
            stroke_circle [16, 16], 16
            bounding_box([8, 32], width: 16, height: 32) do
              text_box "#{record.stamp}", at: [0, 32], size: 16
            end
          elsif record.stamp.length == 3
            stroke_ellipse [12, 14], 12, 20
            bounding_box([6, 31], width: 12, height: 36) do
              text_box "#{record.stamp}", at: [0, 37], size: 12
            end
          elsif record.stamp.length == 4
            stroke do
              rounded_rectangle [2, 45], 30, 30, 3
            end
            bounding_box([4, 35], width: 30, height: 30) do
              text_box "#{record.stamp}", at: [1, 37], size: 13
            end
          else
            image 'app/assets/images/fingerprint.jpg', at: [10, 30], width: 20, height: 30
          end
        end
      end
      stamp_at 'approved', [330, 530]
    end

    def create_footer
      font "app/assets/fonts/SourceHanSans-Bold.ttc" do
      text_box I18n.t('records.new.create_footer1'), at: [70, 70], size: 10
      text_box I18n.t('records.new.create_footer2'), at: [70, 60], size: 10
      end
    end
  end
end