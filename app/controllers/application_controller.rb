class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  def current_user
    @current_user ||= AuthorizeApiRequest.new(request.headers).call[:user]
  end
end
