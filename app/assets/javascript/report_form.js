$(function(){
  reflesh();
});
function reflesh() {
  fertilization_method($('input[name="report[types_of_fertilization_methods]"]:checked').val());
  current_status();
  fuiku_checked($('input[name="report[fuiku]"]:checked').val());
  m_funin_checked($('input[name="report[male_infertility]"]:checked').val());
  embryo_stage_checked($('input[name="report[embryo_stage]"]:checked').val());
  cost_checked($('input[name="report[credit_card_validity]"]:checked').val());
  sairan_count($('#report_number_of_eggs_collected').val());
  transferable_embryos_count_area($('#report_number_of_transferable_embryos').val());
  eggs_calc();
  transferble_embryos_calc();
}

// 2段タブ表示
$(function(){
  $('.btnNext').click(function(){
      var ele = $('.parent-tab-content.active .child-tab .nav-tabs .active').parent().next().find('a');
      if (ele.length == 0) {
        var ele2 = $('.parent-menu .tab-item .active').parent().next().find('a');
        if (ele2.length == 0) {
          $('.parent-menu .tab-item').first().find('a').trigger('click');
        } else {
          ele2.trigger('click');
        }
        $('.parent-tab-content.active .child-tab .nav-tabs li').first().find('a').trigger('click');
      } else {
        ele.trigger('click');
      }
      scrollTabTop();
  });
  
  $('.btnPrevious').click(function(){
      var ele = $('.parent-tab-content.active .child-tab .nav-tabs .active').parent().prev().find('a');
      if (ele.length == 0) {
        var ele2 = $('.parent-menu .tab-item .active').parent().prev().find('a');
        if (ele2.length == 0) {
          $('.parent-menu .tab-item').last().find('a').trigger('click');
        } else {
          ele2.trigger('click');
        }
        $('.parent-tab-content.active .child-tab .nav-tabs li').last().find('a').trigger('click');
      } else {
        ele.trigger('click');
      }
      scrollTabTop();
  });

  $('.FormBtnNext').click(function(){
      var ele = $('.parent-tab-content.active .child-tab .nav-tabs .active').parent().next().find('a');
      if (ele.length == 0) {
        var ele2 = $('.parent-menu .tab-item .active').parent().next().find('a');
        if (ele2.length == 0) {
          $('.parent-menu .tab-item').first().find('a').trigger('click');
        } else {
          ele2.trigger('click');
        }
        $('.parent-tab-content.active .child-tab .nav-tabs li').first().find('a').trigger('click');
      } else {
        ele.trigger('click');
      }
      scrollTabTopForm();
  });
  
  $('.FormBtnPrevious').click(function(){
      var ele = $('.parent-tab-content.active .child-tab .nav-tabs .active').parent().prev().find('a');
      if (ele.length == 0) {
        var ele2 = $('.parent-menu .tab-item .active').parent().prev().find('a');
        if (ele2.length == 0) {
          $('.parent-menu .tab-item').last().find('a').trigger('click');
        } else {
          ele2.trigger('click');
        }
        $('.parent-tab-content.active .child-tab .nav-tabs li').last().find('a').trigger('click');
      } else {
        ele.trigger('click');
      }
      scrollTabTopForm();
  });

  $('.minBtnNext').click(function(){
      var ele = $('.parent-tab-content.active .nav-tabs2 .active').parent().next().find('a');
      if (ele.length == 0) {
        var ele2 = $('.parent-menu .tab-item .active').parent().next().find('a');
        if (ele2.length == 0) {
          $('.parent-menu .tab-item').first().find('a').trigger('click');
        } else {
          ele2.trigger('click');
        }
        $('.parent-tab-content.active .nav-tabs2 li').first().find('a').trigger('click');
      } else {
        ele.trigger('click');
      }
      scrollMinTabTop();
  });
  
  $('.minBtnPrevious').click(function(){
      var ele = $('.parent-tab-content.active .nav-tabs2 .active').parent().prev().find('a');
      if (ele.length == 0) {
        var ele2 = $('.parent-menu .tab-item .active').parent().prev().find('a');
        if (ele2.length == 0) {
          $('.parent-menu .tab-item').last().find('a').trigger('click');
        } else {
          ele2.trigger('click');
        }
        $('.parent-tab-content.active .nav-tabs2 li').last().find('a').trigger('click');
      } else {
        ele.trigger('click');
      }
      scrollMinTabTop();
  });

  $('.minBtnNext2').click(function(){
      var ele = $('.parent-tab-content.active .nav-tabs2 .active').parent().next().find('a');
      if (ele.length == 0) {
        var ele2 = $('.parent-menu .tab-item .active').parent().next().find('a');
        if (ele2.length == 0) {
          $('.parent-menu .tab-item').first().find('a').trigger('click');
        } else {
          ele2.trigger('click');
        }
        $('.parent-tab-content.active .nav-tabs2 li').first().find('a').trigger('click');
      } else {
        ele.trigger('click');
      }
      scrollMinTabTop();
  });
  
  $('.minBtnPrevious2').click(function(){
      var ele = $('.parent-tab-content.active .nav-tabs2 .active').parent().prev().find('a');
      if (ele.length == 0) {
        var ele2 = $('.parent-menu .tab-item .active').parent().prev().find('a');
        if (ele2.length == 0) {
          $('.parent-menu .tab-item').last().find('a').trigger('click');
        } else {
          ele2.trigger('click');
        }
        $('.parent-tab-content.active .nav-tabs2 li').last().find('a').trigger('click');
      } else {
        ele.trigger('click');
      }
      scrollMinTabTop();
  });

  // $('.tab-item a').on('click', function (event) {
  //     var tabEle = $(event.target).closest('ul');
  //     var ele = $(event.target).attr('href');
      
  //     if (tabEle.hasClass('parent-menu')) {
  //       $('.parent-menu a[data-toggle=tab].active').removeClass('active show');
  //     } else if (tabEle.hasClass('child-menu')) {
  //       $('.parent-tab-content.active .child-menu a[data-toggle=tab].active').removeClass('active show');
  //     }
      
  //     if (tabEle.hasClass('nav-bottom')) {
  //       $('ul:not(.nav-bottom) a[href=\\' + ele +']').addClass('active show');
  //     } else {
  //       $('ul.nav-bottom a[href=\\' + ele +']').addClass('active show');
  //     }
  // });
});

function scrollTabTop(){
var offsetTop = $('.landing-point').offset().top -40;
$("html, body").animate({ scrollTop: offsetTop }, 200);
}

function scrollTabTopForm(){
var offsetTop = $('.landing-point').offset().top -130;
$("html, body").animate({ scrollTop: offsetTop }, 200);
}

function scrollMinTabTop(){
var offsetTop = $('.landing-point').offset().top +170;
$("html, body").animate({ scrollTop: offsetTop }, 200);
}


// クリニック選択
$(function() {
  $('#select_prefecture').change(function() {
    $.ajax('/cities_select',
      {
        type: 'get',
        data: { prefecture_id: $(this).val() },
      }
    )
    .done(function(data) {
      $('#city').html(data) 
    })
    .fail(function() {
      window.alert('正しい結果を得られませんでした。');
    });
    $('#report_clinic_id').val('');
  });
});
$(function() {
  $('#city').change(function() {
    $.ajax('/clinics_select',
      {
        type: 'get',
        data: { city_name: $(this).val() },
      }
    )
    .done(function(data) {
      $('#report_clinic_id').html(data) 
    })
    .fail(function() {
      window.alert('正しい結果を得られませんでした。');
    });
  });
});

// クリニックを選択した時点でform内のテキストに表示させる
$(function() {
  var clinic_name = $('#report_clinic_id option:selected').text();
  var clinic_name_description = "「" + clinic_name + "」" + "での治療に関する情報について教えて下さい。";
  var clinic_name_review = clinic_name + "での治療の「満足度」について教えて下さい。";
  var clinic_name_birth = clinic_name + "での治療で妊娠し「出産された方」に教えて下さい。";
  if (clinic_name === "クリニック" ) {
    $('.select-clinic-name').text("このレポコのクリニック");
    $('.select-clinic-description').text("このレポコのクリニックでの治療に関する情報について教えて下さい。");
    $('.select-clinic-review').text("このレポコのクリニックでの治療の満足度について教えて下さい。");
    $('.select-clinic-birth').text("このレポコのクリニックでの治療で妊娠し「出産された方」に教えて下さい。");
  } else {
    $('.select-clinic-name').text(clinic_name);
    $('.select-clinic-description').text(clinic_name_description);
    $('.select-clinic-review').text(clinic_name_review);
    $('.select-clinic-birth').text(clinic_name_birth);
  }
});
$(function() {
  $('#report_clinic_id').change(function() {
    var clinic_name = $('#report_clinic_id option:selected').text();
    var clinic_name_description = "「" + clinic_name + "」" + "での治療に関する情報について教えて下さい。";
    var clinic_name_review = clinic_name + "での治療の「満足度」について教えて下さい。";
    var clinic_name_birth = clinic_name + "での治療で妊娠し「出産された方」に教えて下さい。";
    $('.select-clinic-name').text(clinic_name);
    $('.select-clinic-description').text(clinic_name_description);
    $('.select-clinic-review').text(clinic_name_review);
    $('.select-clinic-birth').text(clinic_name_birth);
  });
});

// ステータスを選択した時点でform内のテキストに表示させる
$(function(){
  $('#report_current_state_1').on('keyup change',function(e){
    current_status();
  });
  $('#report_current_state_2').on('keyup change',function(e){
    current_status();
  });
  $('#report_current_state_3').on('keyup change',function(e){
    current_status();
  });
  $('#report_current_state_4').on('keyup change',function(e){
    current_status();
  });
  $('#report_current_state_99').on('keyup change',function(e){
    current_status();
  });
});
function current_status() {
  let val = $('input[name="report[current_state]"]:checked').val();
  if (val === "1") {
    $('.select-current-status').text("「妊娠中」");
  } else if (val === "2") {
    $('.select-current-status').text("「妊娠中(多胎)」");
  } else if (val === "3") {
    $('.select-current-status').text("「出産」");
  } else if (val === "4") {
    $('.select-current-status').text("「出産(多胎)」");
  } else {
    $('.select-current-status').text("現在の状況");
  }
}

// 治療当時の住まい選択
$(function() {
  $('#report_prefecture_id').change(function() {
    $.ajax('/address_cities_select',
      {
        type: 'get',
        data: { prefecture_id: $(this).val() },
      }
    )
    .done(function(data) {
      $('#report_city_id').html(data) 
    })
    .fail(function() {
      window.alert('正しい結果を得られませんでした。');
    });
  });
});

// 受精方法の詳細
$(function() {
  $('input[name="report[types_of_fertilization_methods]"]:radio').change(function() {
    fertilization_method($(this).val());
  });
})
function fertilization_method(types_of_fertilization_methods) {
  if (types_of_fertilization_methods === "2") {
    $("#detail_of_icsi").show();
  } else if (types_of_fertilization_methods === "3") {
    $("#detail_of_icsi").show();
  } else {
    $("#detail_of_icsi").hide();
    $('input[name="report[details_of_icsi]"]:checked').prop('checked', false);
  }
}

// 不育原因の詳細
$(function() {
  $('input[name="report[fuiku]"]:radio').change(function() {
    fuiku_checked($(this).val());
  });
})
function fuiku_checked(fuiku) {
  if (fuiku === "2") {
    $(".fuiku-factor").show();
  } else if (fuiku === "99") {
    $(".fuiku-factor").show();
  } else {
    $(".fuiku-factor").hide();
    $('input[name="report[fuiku_inspection_ids][]"]:checked').prop('checked', false);
  }
}

// 男性不妊の詳細
$(function() {
  $('input[name="report[male_infertility]"]:radio').change(function() {
    m_funin_checked($(this).val());
  });
})
function m_funin_checked(male_infertility) {
  if (male_infertility === "2") {
    $(".level_of_male_infertility").show();
  } else {
    $(".level_of_male_infertility").hide();
    $('input[name="report[level_of_male_infertility]"]:checked').prop('checked', false);
  }
}

// 卵子内訳足し算
$(function(){
  $('#report_number_of_eggs_collected').on('change keyup', function(){ 
    var eggs = $('#report_number_of_eggs_collected').val();
    eggs_calc();
  });
  $(".egg_details select").on("change keyup",function(){
    eggs_calc();
  });
});
function eggs_calc() {
  var sum = 0;
  $(".egg_details select").each(function(){
    var selected = $(this).val();
    if (selected <= 51) {
      var val = Number(selected);
      sum += val;
      eggs_calc2(sum);
    }
  });
  $(".egg_m2_m1_gv").text(sum + "個");
};
function eggs_calc2(sum) {
  var sabun = $('#report_number_of_eggs_collected').val() - sum
  if (sabun === 0){
    $(".egg_count_result").text("");
    $(".egg_count_result_annotation1").text("");
    $(".egg_count_result_annotation2").text("");
    $(".egg_count_result_annotation3").text("");
  } else if (sabun < 0) {
    var result = -(sabun)
    $(".egg_count_result").css('color','red').text("採卵個数計より" + result + "個多いです");
    $(".egg_count_result_annotation1").text("内訳の合計");
    $(".egg_count_result_annotation2").text(" ≠ ");
    $(".egg_count_result_annotation3").text("採卵個数 でも投稿はできます");
  } else if (sabun > 0) {
    $(".egg_count_result").css('color','red').text("採卵個数計より" + sabun + "個少ないです");
    $(".egg_count_result_annotation1").text("内訳の合計");
    $(".egg_count_result_annotation2").text(" ≠ ");
    $(".egg_count_result_annotation3").text("採卵個数 でも投稿はできます");
  };
  $(".egg_m2_m1_gv").text(sum + "個");
};

// 移植可能胚足し算
$(function(){
  $('#report_number_of_transferable_embryos').on('change keyup', function(){ 
    var transferble_embryos = $('#report_number_of_transferable_embryos').val();
    transferble_embryos_calc();
  });
  $(".transferable_embryos_count_area select").on("change keyup",function(){
    transferble_embryos_calc();
  });
});
function transferble_embryos_calc() {
  var sum = 0;
  $(".transferable_embryos_count_area select").each(function(){
    var selected = $(this).val();
    if (selected <= 51) {
      var val = Number(selected);
      sum += val;
      transferble_embryos_calc2(sum);
    }
  });
  $(".transferable_embryos_count").text(sum + "個");
};
function transferble_embryos_calc2(sum) {
  var sabun = $('#report_number_of_transferable_embryos').val() - sum
  if (sabun === 0){
    $(".transferable_embryos_result").text("");
    $(".transferable_embryos_result_annotation1").text("");
    $(".transferable_embryos_result_annotation2").text("");
    $(".transferable_embryos_result_annotation3").text("");
  } else if (sabun < 0) {
    var result = -(sabun)
    $(".transferable_embryos_result").css('color','red').text("移植可能胚計より" + result + "個多いです");
    $(".transferable_embryos_result_annotation1").text("内訳の合計");
    $(".transferable_embryos_result_annotation2").text(" ≠ ");
    $(".transferable_embryos_result_annotation3").text("移植可能胚数 でも投稿はできます");
  } else if (sabun > 0) {
    $(".transferable_embryos_result").css('color','red').text("移植可能胚計より" + sabun + "個少ないです");
    $(".transferable_embryos_result_annotation1").text("内訳の合計");
    $(".transferable_embryos_result_annotation2").text(" ≠ ");
    $(".transferable_embryos_result_annotation3").text("移植可能胚数 でも投稿はできます");
  };
  $(".transferable_embryos_count").text(sum + "個");
};

// 採卵個数を選んだら成熟度選択欄を表示させる
$(function() {
  $('#report_number_of_eggs_collected').change(function() {
    sairan_count($(this).val());
  });
})
function sairan_count(sairan_count) {
  if (sairan_count == null) {
    $(".sairan_count_area").hide();
    $('#report_egg_m2').val(null);
    $('#report_egg_m1').val(null);
    $('#report_egg_gv').val(null);
  } else if (sairan_count == 0 ) {
    $(".sairan_count_area").hide();
    $('#report_egg_m2').val(null);
    $('#report_egg_m1').val(null);
    $('#report_egg_gv').val(null);
  } else if (sairan_count > 51 ) {
    $(".sairan_count_area").hide();
    $('#report_egg_m2').val(null);
    $('#report_egg_m1').val(null);
    $('#report_egg_gv').val(null);
  } else {
    $(".sairan_count_area").show();
  }
}

// 移植可能胚数を選んだら新鮮胚と凍結胚の選択欄を表示させる
$(function() {
  $('#report_number_of_transferable_embryos').change(function() {
    transferable_embryos_count_area($(this).val());
  });
})
$(".transferable_embryos_count_area").hide();
function transferable_embryos_count_area(transferable_embryos_count_area) {
  if (transferable_embryos_count_area == null) {
    $(".transferable_embryos_count_area").hide();
    $("#report_number_of_unfrozen_embryos").val(null);
    $("#report_number_of_frozen_pronuclear_embryos").val(null);
    $("#report_number_of_frozen_early_embryos").val(null);
    $("#report_number_of_frozen_blastocysts").val(null);
  } else if (transferable_embryos_count_area == 0 ) {
    $(".transferable_embryos_count_area").hide();
    $(".transferable_embryos_count_area").hide();
    $("#report_number_of_unfrozen_embryos").val(null);
    $("#report_number_of_frozen_pronuclear_embryos").val(null);
    $("#report_number_of_frozen_early_embryos").val(null);
    $("#report_number_of_frozen_blastocysts").val(null);
  } else if (transferable_embryos_count_area > 51 ) {
    $(".transferable_embryos_count_area").hide();
    $(".transferable_embryos_count_area").hide();
    $("#report_number_of_unfrozen_embryos").val(null);
    $("#report_number_of_frozen_pronuclear_embryos").val(null);
    $("#report_number_of_frozen_early_embryos").val(null);
    $("#report_number_of_frozen_blastocysts").val(null);
  } else {
    $(".transferable_embryos_count_area").show();
  }
}

// report_transfer_option_ids_1は二段階移植,report_transfer_option_ids_2は複数胚移植、これらを選んだら「移植胚」の項目に以下を表示
$(function(){
  $('#report_transfer_option_ids_1').on('keyup change',function(e){
    var discription1 = "移植オプションで「";
    var discription2 = "二段階移植";
    var discription3 = "」を選択されています。";
    var val = $(this).prop("checked");
    if (val == true) {
      $('.transfer_option_alert1').show();
      $('.transfer_option_dis1').text(discription1);
      $('.transfer_option_dis2').text(discription2);
      $('.transfer_option_dis3').text(discription3);
    } else {
      $('.transfer_option_alert1').hide();
    }
  });
});
$(function(){
  $('#report_transfer_option_ids_2').on('keyup change',function(e){
    var discription1 = "移植オプションで「";
    var discription2 = "複数胚移植";
    var discription3 = "」を選択されています。";
    var val = $(this).prop("checked");
    if (val == true) {
      $('.transfer_option_alert2').show();
      $('.transfer_option_dis4').text(discription1);
      $('.transfer_option_dis5').text(discription2);
      $('.transfer_option_dis6').text(discription3);
    } else {
      $('.transfer_option_alert2').hide();
    }
  });
});
$(function() {
  $('input[name="report[total_number_of_eggs_transplanted]"]:radio').change(function() {
    eggs($(this).val());
  });
})
$(".number_of_eggs").hide();
function eggs(eggs_number) {
  if (eggs_number > 1 && eggs_number < 6) {
    $(".number_of_eggs").show();
  } else {
    $(".number_of_eggs").hide();
  }
};

// 胚のステージ選択
$(function() {
  $('input[name="report[embryo_stage]"]:radio').change(function() {
    embryo_stage_checked($(this).val());
  });
})
// $(".early_embryo_grade").hide();
// $(".blastocyst_grade1").hide();
// $(".blastocyst_grade2").hide();
function embryo_stage_checked(embryo_stage) {
  if (embryo_stage == "1") {
    $(".early_embryo_grade").show();
    $(".blastocyst_grade1").hide();
    $('input[name="report[blastocyst_grade1]"]:checked').prop('checked', false);
    $(".blastocyst_grade2").hide();
    $('input[name="report[blastocyst_grade2]"]:checked').prop('checked', false);
    $(".culture_days").hide();
    $('input[name="report[culture_days]"]:checked').prop('checked', false);
  } else if (embryo_stage == "2") {
    $(".early_embryo_grade").hide();
    $('input[name="report[early_embryo_grade]"]:checked').prop('checked', false);
    $(".blastocyst_grade1").show();
    $(".blastocyst_grade2").show();
    $(".culture_days").show();
  } else {
    $(".early_embryo_grade").hide();
    $('input[name="report[early_embryo_grade]"]:checked').prop('checked', false);
    $(".blastocyst_grade1").hide();
    $('input[name="report[blastocyst_grade1]"]:checked').prop('checked', false);
    $(".blastocyst_grade2").hide();
    $('input[name="report[blastocyst_grade2]"]:checked').prop('checked', false);
    $(".culture_days").hide();
    $('input[name="report[culture_days]"]:checked').prop('checked', false);
  }
}

// 過去の採卵
$(function() {
  $('input[name="report[total_number_of_sairan]"]:radio').change(function() {
    past_sairan_count($(this).val());
  });
})
function past_sairan_count(total_number_of_sairans) {
  var total_number_of_sairan = Number(total_number_of_sairans)
  if (total_number_of_sairan <= 1) {
    $(".past_sairan").hide();
    $(".total_number_of_sairans_sum3").hide();
  } else if (total_number_of_sairan < 15) {
    var num_sairans = total_number_of_sairan - 1
    var total_number_of_sairans_1 = " 過去" + num_sairans + "回分の採卵についてぜひ回答ください！"
    var total_number_of_sairans_2 = "（採卵" + total_number_of_sairan + "回 － " + "最新採卵周期）"
    var total_number_of_sairans_3 = num_sairans + "回"
    $(".total_number_of_sairans_sum").text(total_number_of_sairans_1);
    $(".total_number_of_sairans_sum2").text(total_number_of_sairans_2);
    $(".total_number_of_sairans_sum3").text(total_number_of_sairans_3);
    $(".past_sairan").show();
    $(".total_number_of_sairans_sum2").show();
    $(".total_number_of_sairans_sum3").show();
  } else if (total_number_of_sairan == 15) {
    var total_number_of_sairans_1 = " 過去の採卵についてもぜひ回答ください！"
    $(".total_number_of_sairans_sum").text(total_number_of_sairans_1);
    $(".total_number_of_sairans_sum2").text();
    $(".total_number_of_sairans_sum3").text();
    $(".past_sairan").show();
    $(".total_number_of_sairans_sum2").hide();
    $(".total_number_of_sairans_sum3").hide();
  } else if (total_number_of_sairan == null){
    $(".past_sairan").show();
    $(".total_number_of_sairans_sum3").hide();
  } else {
    $(".past_sairan").hide();
    $(".total_number_of_sairans_sum3").hide();
  }
}

// 過去の移植
$(function() {
  $('input[name="report[total_number_of_transplants]"]:radio').change(function() {
    past_ishoku_count($(this).val());
    choran_ishokukaisu_count($(this).val());
  });
})
function past_ishoku_count(total_number_of_transplants) {
  var total_number_of_transplant = Number(total_number_of_transplants)
  if (total_number_of_transplant <= 1) {
    $(".past_ishoku").hide();
    $(".total_number_of_transplants_sum3").hide();
  } else if (total_number_of_transplant < 15) {
    var num_transplants = total_number_of_transplant - 1
    var total_number_of_transplants_1 = " 過去" + num_transplants + "回分の移植についてぜひ回答ください！"
    var total_number_of_transplants_2 = "（移植" + total_number_of_transplant + "回 － " + "最新移植周期）"
    var total_number_of_transplants_3 = num_transplants + "回"
    $(".total_number_of_transplants_sum").text(total_number_of_transplants_1);
    $(".total_number_of_transplants_sum2").text(total_number_of_transplants_2);
    $(".total_number_of_transplants_sum3").text(total_number_of_transplants_3);
    $(".past_ishoku").show();
    $(".total_number_of_transplants_sum2").show();
    $(".total_number_of_transplants_sum3").show();
  } else if (total_number_of_transplant == 15) {
    var total_number_of_transplants_1 = " 過去の移植についてもぜひ回答ください！"
    $(".total_number_of_transplants_sum").text(total_number_of_transplants_1);
    $(".total_number_of_transplants_sum2").text();
    $(".total_number_of_transplants_sum3").text();
    $(".past_ishoku").show();
    $(".total_number_of_transplants_sum2").hide();
    $(".total_number_of_transplants_sum3").hide();
  } else if (total_number_of_transplant == null){
    $(".past_ishoku").show();
    $(".total_number_of_transplants_sum2").hide();
    $(".total_number_of_transplants_sum3").hide();
  } else {
    $(".past_ishoku").hide();
    $(".total_number_of_transplants_sum3").hide();
  }
}

// 移植可能胚数
$(function() {
  $('#report_number_of_transferable_embryos').change(function() {
    choran_ishokukanouhai_count($(this).val());
  });
})
// 貯卵への注釈
  // 移植回数
function choran_ishokukaisu_count(total_number_of_transplants) {
  var total_number_of_transplant = Number(total_number_of_transplants)
  var total_number_of_transplants_1 = "(移植回数は「" + total_number_of_transplant + "回」を選択中)"
  var total_number_of_transplants_2 = "(移植回数は「" + total_number_of_transplant + "回以上」を選択中)"
  if (total_number_of_transplant < 15) {
    $(".ishokukaisu").show();
    $(".ishokukaisu").text(total_number_of_transplants_1);
  } else if (total_number_of_transplant == 15) {
    $(".ishokukaisu").show();
    $(".ishokukaisu").text(total_number_of_transplants_2);
  } else {
    $(".ishokukaisu").hide();
  }
}
  // 移植可能胚数
function choran_ishokukanouhai_count(number_of_transferable_embryos) {
  var number_of_transferable_embryo = Number(number_of_transferable_embryos)
  var number_of_transferable_embryos_1 = "(移植可能胚数は「" + number_of_transferable_embryo + "個」を選択中)"
  var number_of_transferable_embryos_2 = "(移植可能胚数は「" + number_of_transferable_embryo + "個以上」を選択中)"
  if (number_of_transferable_embryo < 51) {
    $(".ishokukanouhai").show();
    $(".ishokukanouhai").text(number_of_transferable_embryos_1);
  } else if (number_of_transferable_embryo == 51) {
    $(".ishokukanouhai").show();
    $(".ishokukanouhai").text(number_of_transferable_embryos_2);
  } else {
    $(".ishokukanouhai").hide();
  }
}

// 作成中
// $(function(){
//   $('#report_number_of_transferable_embryos').change(function(){ 
//     var transferble_embryos = $('#report_number_of_transferable_embryos').val();
//     if (transferble_embryos != null && transferble_embryos <= 51) {
//       $(".transferble_embryos_sum").text("移植可能胚 " + transferble_embryos + "個");
//     }
//   });
//   $('#report_choran').change(function(){ 
//     var choran = $('#report_choran').val();
//     if (choran <= 51) {
//       $(".report_choran_sum").text("貯卵数 " + choran + "個");
//       $(".report_choran_sum").show();
//     } else {
//       $(".report_choran_sum").hide();
//     }
//   });
// });

// クレジットカードの使用可否
$(function() {
  $('input[name="report[credit_card_validity]"]:radio').change(function() {
    cost_checked($(this).val());
  });
})
// $(".amount_that_can_be_activated").hide();
function cost_checked(credit_card_validity) {
  if (credit_card_validity == "3") {
    $(".amount_that_can_be_activated").show();
  } else {
    $(".amount_that_can_be_activated").hide();
    $('input[name="report[creditcards_can_be_used_from_more_than]"]').val("");
  }
}

// 業種一覧別ウィンドウ
function disp(url){
  window.open(url, "window_name", "width=600,height=500,scrollbars=yes");
}

// 下書きスイッチによって投稿/保存ボタンの切り替え
$(function() {
  $('input[class="draft-switch-btn"]').change(function() {
    var prop = $(this).prop('checked');
    if (prop) {
      $('.post-btn').val("保存");
    } else {
      $('.post-btn').val("投稿");
    }
  });
});

// ラジオボタンチェック外し
var remove = 0;
function radioDeselection(already, numeric) {
  if(remove == numeric) {
    already.checked = false;
    remove = 0;
  } else {
    remove = numeric;
  }
  reflesh();
}

// コメント文字数カウント
$(function (){
  var count = $(".js-text").text().replace(/\n/g, "改行").length;
  var now_count = 500 - count;
  if (count > 500) {
    $(".js-text-count").css("color","red");
  } else {
    $(".js-text-count").css("color","#808080");
  }
  $(".js-text-count").text( "残り" + now_count + "文字");

  $(".js-text").on("keyup", function() {
    var count = $(this).val().replace(/\n/g, "改行").length;
    var now_count = 500 - count;

    if (count > 500) {
      $(".js-text-count").css("color","red");
      var status = (now_count * -1) + "文字オーバーしています！"
    } else {
      $(".js-text-count").css("color","#808080");
      var status = "残り" + now_count + "文字"
    }
    $(".js-text-count").text(status);
  });
});

// title文字数カウント
$(function (){
  var count = $(".title-js-text").text().replace(/\n/g, "改行").length;
  var now_count = 64 - count;
  if (count > 64) {
    $(".title-js-text-count").css("color","red");
  } else {
    $(".title-js-text-count").css("color","#808080");
  }
  $(".title-js-text-count").text( "上限まで残り" + now_count + "文字");

  $(".title-js-text").on("keyup", function() {
    var count = $(this).val().replace(/\n/g, "改行").length;
    var now_count = 64 - count;

    if (count > 64) {
      $(".title-js-text-count").css("color","red");
      var status = (now_count * -1) + "文字オーバーしています！"
    } else {
      $(".title-js-text-count").css("color","#808080");
      var status = "上限まで残り" + now_count + "文字"
    }
    $(".title-js-text-count").text(status);
  });
});

// 数字リアルタイム3桁区切り
// 参考記事→ https://qiita.com/tsunet111/items/5531e2fd4d5b55e70f40
// これを有効にする場合には.commasが付与されているformのtypeをnumber_fieldからtext_fieldに変更のこと。
// function updateTextView(_obj){
//   var num = getNumber(_obj.val());
//   if(num==0){
//     _obj.val('');
//   }else{
//     _obj.val(num.toLocaleString());
//   }
// }
// function getNumber(_str){
//   var arr = _str.split('');
//   var out = new Array();
//   for(var cnt=0;cnt<arr.length;cnt++){
//     if(isNaN(arr[cnt])==false){
//       out.push(arr[cnt]);
//     }
//   }
//   return Number(out.join(''));
// }
// $(function(){
//   $('.commas').on('keyup',function(){
//     updateTextView($(this));
//   });
// });
