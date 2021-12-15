# EffectiveOrganizationsUser
#
# Mark your user model with effective_organizations_user to get all the includes

module EffectiveOrganizationsUser
  extend ActiveSupport::Concern

  module Base
    def effective_organizations_user(organizations_source_type: nil)
      @effective_organizations_user_opts = {
        organizations_source_type: organizations_source_type
      }

      include ::EffectiveOrganizationsUser
    end
  end

  module ClassMethods
    def effective_organizations_user?; true; end
  end

  included do
    # My teams
    has_many :representatives, -> { Effective::Representative.sorted },
      class_name: 'Effective::Representative', inverse_of: :user, dependent: :delete_all

    # App scoped
    has_many :organizations, through: :representatives,
      source_type: @effective_organizations_user_opts[:organizations_source_type] || "#{name.split('::').first}::Organization"
  end

  def representative(organization:)
    representatives.find { |rep| rep.organization_id == organization.id }
  end

end
