class RecordsController < ApplicationController
  def new
    @record = RecordsForm.new
  end

  def create
    @record = RecordsForm.new(record_params)
    if @record.valid?
      post_pdf = NotificationPdf::PostPdf.new(@record).render
      send_data post_pdf,
        filename: 'post_pdf.pdf',
        type: 'application/pdf',
        disposition: 'inline'
    else
      render :new, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error("PDF generation failed: #{e.message}")
    flash.now[:alert] = I18n.t('defaults.pdf_error')
    render :new, status: :internal_server_error
  end

  def terms; end

  def privacy_policy; end

  private

  def record_params
    params.require(:records_form).permit(:myname, :stamp, :old, :fromdate, :todate, :yourname, :getup, :cleanup, :remark)
  end
end
