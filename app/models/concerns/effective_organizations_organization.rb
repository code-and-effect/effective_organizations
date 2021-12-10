# EffectiveMembershipsCategory
#
# Mark your category model with effective_memberships_category to get all the includes

module EffectiveOrganizationsOrganization
  extend ActiveSupport::Concern

  module Base
    def effective_organizations_organization
      include ::EffectiveOrganizationsOrganization
    end
  end

  module ClassMethods
    def effective_organizations_organization?; true; end

    def categories
      []
    end
  end

  included do
    log_changes(except: :representatives) if respond_to?(:log_changes)

    # rich_text_body
    # has_many_rich_texts

    has_many :representatives, -> { Effective::Representative.sorted },
      class_name: 'Effective::Representative', inverse_of: :organization, dependent: :delete_all

    has_many :users, through: :representatives

    effective_resource do
      title                 :string
      category              :string

      notes                 :text

      representatives_count :integer # Counter cache

      timestamps
    end

    scope :deep, -> { includes(:representatives) }
    scope :sorted, -> { order(:title) }

    validates :title, presence: true, uniqueness: true
  end

  # Instance Methods

  def to_s
    title.presence || 'New Organization'
  end

end
