module UsersConcern
  extend ActiveSupport::Concern
  
  def update_status_according_to_role
    if @user.Admin?
      @loan_request.update(status: 'waiting_for_adjustment_acceptance')
    else
      @loan_request.update(status: 'readjustment_requested')
    end
  end

  def format_nested_attribute_hash
    params[:loan_request].merge!(loan_request_readjustments_attributes:
                    [{loan_request_id: params[:id].to_i,
                    previous_amount: @loan_request.desired_amount, readjusted_amount: params[:loan_request][:desired_amount],
                    previous_interest: @loan_request.desired_interest, readjusted_interest: params[:loan_request][:desired_interest],
                    previous_tenure: @loan_request.loan_tenure, readjusted_tenure: params[:loan_request][:loan_tenure],
                    readjusted_by: @user.role == 'Admin' ? 'Admin' : "#{@user.first_name}",_destroy: false}])
  end
end