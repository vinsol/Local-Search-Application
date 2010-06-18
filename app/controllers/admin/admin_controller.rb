class Admin::AdminController < ApplicationController
  before_filter :check_admin
  def index
  end
end
