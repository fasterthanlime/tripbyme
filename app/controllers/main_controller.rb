class MainController < ApplicationController
  def index
    @collect_data = (params[:collect_data] == '1')
  end

end
