require 'effective_resources'
require 'effective_datatables'
require 'effective_organizations/engine'
require 'effective_organizations/version'

module EffectiveOrganizations

  def self.config_keys
    [
      :organizations_table_name, :representatives_table_name, :layout,
      :organization_class_name
    ]
  end

  include EffectiveGem

  def self.Organization
    organization_class_name&.constantize || Effective::Organization
  end

end
