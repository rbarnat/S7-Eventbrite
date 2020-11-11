module ApplicationHelper
  def user_is_admin?
    return (user_signed_in? && current_user.is_admin)
  end

  def bootstrap_class_for_flash(type)
    case type
      when 'notice' then "alert-info"
      when 'success' then "alert-success"
      when 'error' then "alert-danger"
      when 'alert' then "alert-warning"
    end
  end
end
