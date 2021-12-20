# EffectiveOrganizationsOrganization
#
# Mark your category model with effective_organizations_organization to get all the includes

module EffectiveOrganizationsOrganization
  extend ActiveSupport::Concern

  module Base
    def effective_organizations_organization(users_source_type: nil)
      @effective_organizations_organization_opts = {
        users_source_type: users_source_type
      }

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

    has_many :users, through: :representatives,
      source_type: (@effective_organizations_organization_opts[:users_source_type] || (name.start_with?('Effective') ? '::User' : "#{name.split('::').first}::Organization"))

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

  def representative(user:)
    representatives.find { |rep| rep.user_id == user.id }
  end

  # Find or build
  def build_representative(user:)
    representative(user: user) || representatives.build(user: user)
  end

end
