class Admin::AdminController < Admin::ApplicationController

  def home
    @reports = Report.all.includes(:user, :clinic).order("created_at DESC")
    @released_reports = Report.released.all.includes(:user, :clinic).order("created_at DESC")
    @users = User.all.includes(:reports).order("created_at DESC")
    @clinics = Clinic.all.includes(:reports)
    @clinics_reports = Clinic.joins(:reports).group(:id).order("created_at DESC")
    @clinics_count = Report.group(:clinic_id).size
    @clinics_count_released = Report.released.group(:clinic_id).size
  end

end