require 'rails_helper'

module Decidim::Govbr
  RSpec.describe PromotedToAdminMailer do
    include ActionView::Helpers::SanitizeHelper

    let(:organization) { create(:organization) }
    let(:participatory_process) { create(:participatory_process, organization: organization) }
    let(:user) { create(:user, organization: organization, locale: :'pt-BR') }
    let(:mail) { described_class.notification(user) }

    describe '.notification' do
      context 'when it is called with a valid user' do
        it 'sends an email containing information about the user promotion' do
          I18n.with_locale(:'pt-BR') do
            expect(email_body(mail)).to have_tag('p', :seen => "Olá, #{user.name}!")
            expect(email_body(mail)).to have_tag('p', :seen => "Informamos que seu usuário foi promovido a administrador da plataforma #{organization.name}. Este é um e-mail automático e não deve ser respondido.")
          end
        end
      end
    end
  end
end