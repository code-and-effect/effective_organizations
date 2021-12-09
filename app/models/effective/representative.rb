module Effective
  class Representative < ActiveRecord::Base
    acts_as_role_restricted

    log_changes(to: :organization) if respond_to?(:log_changes)

    belongs_to :organization, polymorphic: true, counter_cache: true
    belongs_to :user, polymorphic: true

    effective_resource do
      roles_mask    :integer

      timestamps
    end

    scope :sorted, -> { order(:id) }
    scope :deep, -> { includes(:user, :organization) }

    validates :organization, presence: true
    validates :user, presence: true

    validates :user_id, if: -> { user_id && user_type && organization_id },
      uniqueness: { scope: [:organization_id], message: 'already belongs to this organization' }

    validates :roles, presence: true

    def to_s
      user.to_s
    end

  end
end
