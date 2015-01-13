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
      ## This a global approver.  With this permission.
      ## can view all orders that need approving
      ## && can approve or reject the order.
      def can_manage_order_holds
        ## Can view the approvals section
        can :view_order_approval_section, Order
        can :read, Order
        can :manage, OrderHold
      end

      def can_approve_sub_order_holds
        ## Can view the approvals section
        can :view_order_approval_section, Order
        ## the order hold record has a column claim_id
        ## That claim_id defines which claim the order will need
        ## approval from.
        UserEditContext.call(@user, @site)
        ids = @user.full_claims.map { |claim| claim.id }

        ## Can read any order for which there is at least 1 order_hold that needs approval
        can :read, Order, id: Order.for_approvals(ids).pluck(:id)

        can :view, OrderHold, claim_id: ids
        can :read, OrderHold, claim_id: ids
        can :manage, OrderHold, claim_id: ids
        can :approve_sub_orders, OrderHold, claim_id: ids
      end
    end
  end

end

require 'order_approval/railtie' if defined?(Rails)
