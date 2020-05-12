module NotificationsHelper
  def unchecked_notifications
    if current_user.nil?
      @notifications = []
    else
      @notifications = current_user.passive_notifications.where(checked: false)
    end
  end
end