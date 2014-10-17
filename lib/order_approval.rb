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

      def can_manage_order_holds
        can :manage, OrderHold
      end

      def can_approve_sub_order_holds
        ## the order hold record has a column claim_id
        ## That claim_id defines which claim the order will need
        ## approval from.
        UserEditContext.call(@user, @site)
        ids = @user.full_claims.map { |claim| claim.id }
        can :view, OrderHold, claim_id: ids
        can :read, OrderHold, claim_id: ids
        can :manage, OrderHold, claim_id: ids
        can :approve_sub_orders, OrderHold, claim_id: ids
      end
    end
  end

end

require 'order_approval/railtie' if defined?(Rails)
