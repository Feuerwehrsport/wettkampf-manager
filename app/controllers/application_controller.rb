class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ResourceAccess
  include AutoDecorate
  include CRUD::Accessor
end
