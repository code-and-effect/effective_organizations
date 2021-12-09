# EffectiveOrganizationsUser
#
# Mark your user model with effective_organizations_user to get all the includes

module EffectiveOrganizationsUser
  extend ActiveSupport::Concern

  module Base
    def effective_organizations_user
      include ::EffectiveOrganizationsUser
    end
  end

  module ClassMethods
    def effective_organizations_user?; true; end
  end

  included do
  end

end
