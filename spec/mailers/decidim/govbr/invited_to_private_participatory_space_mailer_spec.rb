require 'rails_helper'

module Decidim::Govbr
  RSpec.describe InvitedToPrivateParticipatorySpaceMailer do
    include ActionView::Helpers::SanitizeHelper

    let(:organization) { create(:organization) }
    let(:participatory_process) { create(:participatory_process, organization: organization) }
    let(:user) { create(:user, organization: organization, locale: :'pt-BR') }
    let(:mail) { described_class.notification(user, participatory_process) }

    describe '.notification' do
      context 'when it is called with a valid user and participatory space' do
        it 'sends an email containing information about the participatory space' do
          I18n.with_locale(:'pt-BR') do
            participatory_process.title[:'pt-BR'] = 'Organizacao de Teste'
            expect(email_body(mail)).to have_tag('p', :text => I18n.t('decidim.govbr.invited_to_private_participatory_space_mailer.notification.greetings', user: user.name))
          end
        end
      end
    end
  end
end