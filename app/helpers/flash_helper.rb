# frozen_string_literal: true

module FlashHelper
  def alert_class_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-danger',
      notice: 'alert-info',
    }[flash_type.to_sym] || flash_type.to_s
  end

  def alert_icon_for(flash_type)
    {
      success: 'fa-check',
      notice: 'fa-info-circle',
      error: 'fa-ban',
      alert: 'fa-ban',
    }[flash_type.to_sym] || 'fa-info-circle'
  end
end
