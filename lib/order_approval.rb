require "order_approval/version"

module OrderApproval
  class OrderApprovalFeatureDefinition
    include FeatureSystem::Provides
    def permissions
      [
        {
          can: true,
          callback_name: 'can_manage_order_holds',
          name: 'Can Manage Order Approvals'
        },
        {
          can: true,
          callback_name: 'can_approve_sub_order_holds',
          name: 'Can Manage Order Approvals in Sub Roles'
        }
      ]
    end
  end

  module Authorization
    module Permissions
      ## TODO - Not able to get this working
      #def can_manage_order_holds
      #  can :manage, OrderHold
      #end

      #def can_approve_sub_order_holds
      #  UserEditContext.call(@user, @site)
      #  sub_claim_ids = @user.full_claims.map do |claim|
      #    claim.descendants
      #  end.flatten.map(&:id)

      #  can :view, OrderHold, claim_id: sub_claim_ids
      #  can :read, OrderHold, claim_id: sub_claim_ids
      #  can :manage, OrderHold, claim_id: sub_claim_ids
      #  can :approve_sub_orders, OrderHold, claim_id: sub_claim_ids
      #end
    end
  end

end

require 'order_approval/railtie' if defined?(Rails)
