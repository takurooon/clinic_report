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
    @reports = Report.where(amh: amh_value)
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
    clinic = params[:value]
    @clinics = Clinic.find_by(name: clinic)
    @reports = Report.where(clinic_id: @clinics.id)
    @clinic_reports = Report.where(activated: true).search(params[:search])
  end

  def clinic_prefecture
    prefecture = params[:value]
    @prefecture = Prefecture.find_by(name: prefecture)
    cities = City.where(prefecture_id: @prefecture)
    clinics = Clinic.where(city_id: cities.ids)
    @reports = Report.where(clinic_id: clinics.ids)
  end
  
  def clinic_city
    city = params[:value]
    @city = City.find_by(name: city)
    clinics = Clinic.where(city_id: @city.id)
    @reports = Report.where(clinic_id: clinics.ids)
  end

  def all_age
    age = Report::HASH_TREATMENT_END_AGE
    reports = Report.group(:treatment_end_age).where.not(treatment_end_age: nil).distinct.count
    c = age.keys - reports.keys
    c.each do |d|
      age.delete(d)
    end
    @age = age
  end

  def age
    age = Report::HASH_TREATMENT_END_AGE
    age_value = params[:value].to_i
    @selected_age = age[age_value]
    @reports = Report.where(treatment_end_age: age_value)
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
    gender = params[:gender]
    factor_name = params[:value]
    if gender == "female"
      @factor = FInfertilityFactor.find_by(name: factor_name)
      @reports = @factor.reports
      @factors = FInfertilityFactor.page(params[:page]).per(10)
    else
      @factor = MInfertilityFactor.find_by(name: factor_name)
      @reports = @factor.reports
      @factors = MInfertilityFactor.page(params[:page]).per(10)
    end
  end

  def all_area
  end

  def area_prefecture
    @prefecture = Prefecture.find_by(id: params[:value])
    @reports = Report.where(prefecture_id: @prefecture.id)
  end

  def area_city
    @city = City.find_by(id: params[:value])
    @reports = Report.where(city_id: @city.id)
  end
end