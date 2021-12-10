class EffectiveRepresentativesDatatable < Effective::Datatable
  datatable do
    col :id, visible: false

    col :organization
    col :user

    col :email do |representative|
      mail_to(representative.user.email)
    end

    col :roles, search: roles_collection

    actions_col
  end

  collection do
    Effective::Representative.deep.all.where(organization: current_user.organizations)
  end

  def roles_collection
    EffectiveRoles.roles_collection(Effective::Representative.new).map(&:second)
  end

end
