module Effective
  class Organization < ActiveRecord::Base
    self.table_name = EffectiveMemberships.organizations_table_name.to_s

  end
end
