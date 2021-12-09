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
    # App scoped
    has_many :organizations, through: :representatives

    # My teams
    has_many :representatives, -> { Effective::Representative.sorted }, class_name: 'Effective::Representative', dependent: :delete_all
  end

end
