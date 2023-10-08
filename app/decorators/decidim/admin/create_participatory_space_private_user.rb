# frozen_string_literal: true

Decidim::Admin::CreateParticipatorySpacePrivateUser.class_eval do
  # The customized function comes originally from the file
  # https://github.com/decidim/decidim/blob/release/0.27-stable/decidim-admin/app/commands/decidim/admin/create_participatory_space_private_user.rb#L61-L72
  def existing_user
    return @existing_user if defined?(@existing_user)

    @existing_user = User.find_by(
      email: form.email,
      organization: private_user_to.organization
    )

    if @existing_user&.invitation_pending?
      InviteUserAgain.call(@existing_user, invitation_instructions)
    else
      send_notification_email_to_existing_user
    end

    @existing_user
  end

  def send_notification_email_to_existing_user
    return unless @existing_user
    Decidim::Govbr::InvitedToPrivateParticipatorySpaceMailer.notification(@existing_user, @private_user_to).deliver_later
  end
end