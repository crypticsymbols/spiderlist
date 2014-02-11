class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # see: https://github.com/ryanb/cancan/issues/835#issuecomment-18663815
  before_filter do
  	resource = controller_name.singularize.to_sym
  	method = "#{resource}_params"
  	params[resource] &&= send(method) if respond_to?(method, true)
  end

  before_filter do
    if user_signed_in?
      @message = Feedback.new
    end
  end

  private

end
