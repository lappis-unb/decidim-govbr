# frozen_string_literal: true

Decidim::InviteUser.class_eval do
  # The customized functions comes originally from the file
  # https://github.com/decidim/decidim/blob/release/0.27-stable/decidim-core/app/commands/decidim/invite_user.rb#L33-L38
  def update_user
    user.admin = form.role == "admin"
    user.roles << form.role if form.role != "admin"
    user.roles = user.roles.uniq.compact
    user.save!
    send_notification_email_to_existing_user
  end

  def send_notification_email_to_existing_user
    return unless form.role == "admin"
    Decidim::Govbr::PromotedToAdminMailer.notification(user).deliver_later
  end
end