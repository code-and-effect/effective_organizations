module Admin
  class EffectiveRepresentativesDatatable < Effective::Datatable
    datatable do
      col :id, visible: false

      col :organization
      col :user

      col :roles, search: roles_collection

      actions_col
    end

    collection do
      Effective::Representative.deep.all
    end

    def roles_collection
      EffectiveRoles.roles_collection(Effective::Representative.new).map(&:second)
    end

  end
end
