module OrderApproval
  class Railtie < Rails::Railtie

    initializer "my_railtie.configure_rails_initialization" do |app|
      FeatureBase.register(app, OrderApproval)
    end

    config.after_initialize do
      FeatureBase.inject_feature_record("Order Approvals",
        "OrderApproval",
        "This will enable order approvals."
      )
      FeatureBase.inject_permission_records(
        OrderApproval,
        OrderApprovalFeatureDefinition.new.permissions
      )
    end

  end
end
