class SearchesController < ApplicationController

  def all_amh
    amhs = Report::HASH_AMH
    reports = Report.group(:amh).where.not(amh: nil).distinct.count
    c = amhs.keys - reports.keys
    c.each do |d|
      amhs.delete(d)
    end
    @amhs = amhs
  end

  def amh
    amh = Report::HASH_AMH
    amh_value = params[:value].to_i
    @selected_amh = amh[amh_value]
    @amh = Report.where(amh: amh_value)
    @amh_page = Report.page(params[:page]).per(10)
  end

  def tags
    report_tags = ReportTag.group(:tag_id).where.not(tag_id: nil).distinct.count
    tag = report_tags.keys
    @tags = Tag.where(id: tag)
    @tags_page = Tag.page(params[:page]).per(30)
  end

  def tag
    tag_name = params[:tag_name]
    @tag = Tag.find_by(tag_name: tag_name)
    @reports = @tag.reports
    @tags = Tag.page(params[:page]).per(10)
  end

  def clinics
    @clinics = Clinic.all
  end

  def clinic
    clinic = params[:name]
    @clinics = Clinic.find(clinic)
    @reports = Report.where(clinic_id: clinic)
    @clinic_reports = Report.where(activated: true).search(params[:search])
  end

  def all_age
    age = Report.make_select_options_treatment_end_age.invert
    reports = Report.group(:treatment_end_age).where.not(treatment_end_age: nil).distinct.count
    c = age.keys - reports.keys
    c.each do |d|
      age.delete(d)
    end
    @age = age
  end

  def age
    age = Report.make_select_options_treatment_end_age.invert
    age_value = params[:value].to_i
    @selected_age = age[age_value]
    @age = Report.where(treatment_end_age: age_value)
  end

  def factors
    report_f_factors = ReportFInfertilityFactor.group(:f_infertility_factor_id).where.not(f_infertility_factor_id: nil).distinct.count
    f_factor = report_f_factors.keys
    @f_factors = FInfertilityFactor.where(id: f_factor)
    @f_factors_page = FInfertilityFactor.page(params[:page]).per(30)

    report_m_factors = ReportMInfertilityFactor.group(:m_infertility_factor_id).where.not(m_infertility_factor_id: nil).distinct.count
    m_factor = report_m_factors.keys
    @m_factors = MInfertilityFactor.where(id: m_factor)
    @m_factors_page = MInfertilityFactor.page(params[:page]).per(30)
  end

  def factor
    s = params[:name]
    f_factor_name = params[:value]
    @f_factor = FInfertilityFactor.find_by(name: f_factor_name)
    @f_reports = @f_factor.reports
    @f_factors = FInfertilityFactor.page(params[:page]).per(10)

    m_factor_name = params[:value]
    @m_factor = MInfertilityFactor.find_by(name: m_factor_name)
    @m_reports = @m_factor.reports
    @m_factors = MInfertilityFactor.page(params[:page]).per(10)
  end

  def all_area
  end

  def area_prefecture
    @prefecture = Prefecture.find_by(id: params[:value])
    @reports= Report.joins(prefecture: :cities).where(prefecture_id: params[:value] ).distinct
  end

  def area_city
    city = params[:value]
    @cities = City.find(city)
    @reports = Report.where(city_id: city)
  end
end