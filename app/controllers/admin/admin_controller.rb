class Admin::AdminController < Admin::ApplicationController

  def home
    @reports = Report.all.includes(:user, :clinic).order("created_at DESC")
    @users = User.all.includes(:reports).order("created_at DESC")
    @clinics = Clinic.all.includes(:reports)
    @clinics_reports = Clinic.joins(:reports).group(:id).order("created_at DESC")
  end

end