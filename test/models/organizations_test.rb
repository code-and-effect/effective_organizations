require 'test_helper'

class OrganizationsTest < ActiveSupport::TestCase
  test 'organiozation' do
    user = build_user()
    assert user.valid?
  end

end
