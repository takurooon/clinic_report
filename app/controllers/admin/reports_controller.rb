class Admin::ReportsController < Admin::ApplicationController
  def show
    @report = Report.find(params[:id])
    
    @clinics = @report.itinerary_of_choosing_a_clinics.order(order_of_transfer: "desc")
    @clinics_exist = @clinics.map { |i| i[:clinic_id] }

    @unsuccessful_sairan_cycles = @report.unsuccessful_sairan_cycles.order(un_sairan_number: "asc")
    @unsuccessful_ishoku_cycles = @report.unsuccessful_ishoku_cycles.order(un_ishoku_number: "asc")

    @special_inspection_era = @report.special_inspections.where(name: 1)
    @special_inspection_emma = @report.special_inspections.where(name: 2)
    @special_inspection_alice = @report.special_inspections.where(name: 3)
    @special_inspection_trio = @report.special_inspections.where(name: 4)
    @special_inspection_erpeak = @report.special_inspections.where(name: 5)
    @special_inspection_hysteroscopy = @report.special_inspections.where(name: 6)
    @special_inspection_intrauterine_flora = @report.special_inspections.where(name: 7)
    @special_inspection_endometrial_biopsy = @report.special_inspections.where(name: 8)
    @special_inspection_hidukeshin = @report.special_inspections.where(name: 9)
    @special_inspection_bce = @report.special_inspections.where(name: 10)
    @special_inspection_chromosome = @report.special_inspections.where(name: 11)
    @special_inspection_ca125 = @report.special_inspections.where(name: 12)
    @special_inspection_mri = @report.special_inspections.where(name: 13)
    @special_inspection_vitamin_d = @report.special_inspections.where(name: 14)
    @special_inspection_copper_zinc = @report.special_inspections.where(name: 15)
    @special_inspection_kruger = @report.special_inspections.where(name: 16)
    @special_inspection_dfi = @report.special_inspections.where(name: 17)
    @special_inspection_pgta = @report.special_inspections.where(name: 18)
    @special_inspection_other_inspection = @report.special_inspections.where(name: 99)

    gon.clinic_name = @report.clinic.name
    gon.clinic_evaluation = []
    gon.clinic_evaluation << @report.doctor_quality << @report.staff_quality << @report.impression_of_technology << @report.impression_of_price << @report.average_waiting_time2 << @report.comfort_of_space
    @clinic_evaluation = gon.clinic_evaluation.compact

    if @report.doctor_quality.blank?
      @report.doctor_quality = 0
    end
    if @report.staff_quality.blank?
      @report.staff_quality = 0
    end
    if @report.impression_of_technology.blank?
      @report.impression_of_technology = 0
    end
    if @report.impression_of_price.blank?
      @report.impression_of_price = 0
    end
    if @report.average_waiting_time2.blank?
      @report.average_waiting_time2 = 0
    end
    if @report.comfort_of_space.blank?
      @report.comfort_of_space = 0
    end
    @average_score = ((@report.doctor_quality + @report.staff_quality + @report.impression_of_technology + @report.impression_of_price + @report.average_waiting_time2 + @report.comfort_of_space)/6.to_f).round(1)
  end
end