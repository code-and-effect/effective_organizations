# EffectiveOrganizationsOrganization
#
# Mark your category model with effective_organizations_organization to get all the includes

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
    log_changes(except: [:representatives, :users]) if respond_to?(:log_changes)

    # rich_text_body
    # has_many_rich_texts

    has_many :representatives, -> { Effective::Representative.sorted },
      class_name: 'Effective::Representative', inverse_of: :organization, dependent: :delete_all

    accepts_nested_attributes_for :representatives, allow_destroy: true

    effective_resource do
      title                 :string
      email                 :string

      category              :string

      notes                 :text

      roles_mask            :integer
      archived              :boolean

      representatives_count :integer # Counter cache

      timestamps
    end

    scope :deep, -> { includes(:representatives) }
    scope :sorted, -> { order(:title) }

    validates :title, presence: true, uniqueness: true
  end

  # Instance Methods

  def representative(user:)
    representatives.find { |rep| rep.user_id == user.id }
  end

  # Find or build
  def build_representative(user:)
    representative(user: user) || representatives.build(user: user)
  end

  def users
    representatives.reject(&:marked_for_destruction?).map(&:user)
  end

end
