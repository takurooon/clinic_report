class Admin::ApplicationController < ActionController::Base
    @reports = Report.all.includes(:user, :clinic)
    @users = User.all.includes(:reports)
    @clinics = Clinic.all.includes(:reports)
end