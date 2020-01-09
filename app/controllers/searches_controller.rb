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
    @amhs = Report::HASH_AMH
    amh_value = params[:value].to_i
    @selected_amh = @amhs[amh_value]
    @amh = Report.where(amh: amh_value)
  end

  def tags
    @tags = Tag.page(params[:page]).per(30)
  end

  def tag
    tag_name = params[:tag_name]
    @tag = Tag.find_by(tag_name: tag_name)
    @reports = @tag.reports
    @tags = Tag.page(params[:page]).per(10)
  end

  def clinics
  end

  def clinic
  end
end