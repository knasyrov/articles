class ApplicationController < ActionController::Base

  def page_parameter(param_name = :page)
    params[param_name].to_i.positive? ? params[param_name].to_i : 1
  end

  def per_page_parameter(param_name: :per)
    params[param_name].to_i.positive? ? params[param_name].to_i : 3
  end
    
end
