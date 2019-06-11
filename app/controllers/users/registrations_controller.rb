class Users::RegistrationsController < Devise::RegistrationsController
    before_action :select_plan, only: :new
    
    # Extend default Devise gem behaviour so that users signing up with pro account save with special
    # Stripe subscription function. Otherwise Devise signs up user as usual.
    def create
        super do |resource|
            if params[:plan]
                resource.plan_id = params[:plan]
                if resource.plan.id == 2
                    resource.save_with_subscription
                else
                    resource.save
                end
            end
        end
    end
    
    private
        def select_plan
            unless (params[:plan] == '1' || params[:plan] == '2')
                flash[:notice] = "Plese select a membership plan to sign up"
                redirect_to root_url
            end
        end
end 