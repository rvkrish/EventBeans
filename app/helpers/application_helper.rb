module ApplicationHelper
  def bootstrap_class_for_flash(flash_type)
    case flash_type.to_sym
    when :notice
      'alert-success'
    when :alert, :error
      'alert-danger'
    else
      flash_type.to_s
    end
  end
end
