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
var offsetTop = $('.parent-tab-content.active').offset().top -100;
$("html, body").animate({ scrollTop: offsetTop }, 200);
}

function scrollMinTabTop(){
var offsetTop = $('.parent-tab-content.active').offset().top -30;
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
  var clinic_name_description = "「" + clinic_name + "」" + "での治療に関する情報についてお聞きします。";
  var clinic_name_review = clinic_name + "での治療の「満足度」についてお聞きします。";
  var clinic_name_birth = clinic_name + "での治療で妊娠し「出産された方」にお聞きします。";
  if (clinic_name === "クリニック" ) {
    $('.select-clinic-name').text("このレポコのクリニック");
    $('.select-clinic-description').text("このレポコのクリニックでの治療に関する情報についてお聞きします。");
    $('.select-clinic-review').text("このレポコのクリニックでの治療の満足度についてお聞きします。");
    $('.select-clinic-birth').text("このレポコのクリニックでの治療で妊娠し「出産された方」にお聞きします。");
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
    var clinic_name_description = "「" + clinic_name + "」" + "での治療に関する情報についてお聞きします。";
    var clinic_name_review = clinic_name + "での治療の「満足度」についてお聞きします。";
    var clinic_name_birth = clinic_name + "での治療で妊娠し「出産された方」にお聞きします。";
    $('.select-clinic-name').text(clinic_name);
    $('.select-clinic-description').text(clinic_name_description);
    $('.select-clinic-review').text(clinic_name_review);
    $('.select-clinic-birth').text(clinic_name_birth);
  });
});

// ステータスを選択した時点でform内のテキストに表示させる
$(function() {
  var current_state = $('#report_current_state option:selected').text();
  var status = "「" + current_state + "」";
  if (current_state === "選択") {
    $('.select-current-status').text("現在の状況");
    $('.select-current-status2').text("現状");
  } else {
    $('.select-current-status').text(status);
    $('.select-current-status2').text(status);
  }
});
$(function() {
  $('#report_current_state').change(function() {
    var current_state = $('#report_current_state option:selected').text();
    var status = "「" + current_state + "」";
    $('.select-current-status').text(status);
    $('.select-current-status2').text(status);
  });
});

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

// 用いた卵子と精子の説明①
$(function() {
  eggsperm($("#report_types_of_eggs_and_sperm option:selected").val());
  $("#report_types_of_eggs_and_sperm").change(function() {
    eggsperm($(this).val());
  });
})
function eggsperm(types_of_eggs_and_sperm) {
  if (types_of_eggs_and_sperm > "1") {
    $(".description_of_eggs_and_sperm_used").show();
  } else {
    $(".description_of_eggs_and_sperm_used").hide();
  }
}
// フォーム内の①卵子と精子の回答によって次項のテキストを変える
$(function() {
  var egg_sparm1 = $('#report_types_of_eggs_and_sperm option:selected').text();
  var egg_sparm1_memo = egg_sparm1 + "についての詳しい説明";
  if (egg_sparm1 === "提供卵子" || egg_sparm1 === "提供精子") {
    $('.select-egg-sparm1').text(egg_sparm1_memo);
    $(".egg_sparm1_default2").show();
    $(".egg_sparm1_default").hide();
  } else {
    $(".egg_sparm1_default2").hide();
    $(".egg_sparm1_default").show();
  }
});
$(function() {
  $('#report_types_of_eggs_and_sperm').change(function() {
    var egg_sparm1 = $('#report_types_of_eggs_and_sperm option:selected').text();
    var egg_sparm1_memo = egg_sparm1 + "についての詳しい説明";
    if (egg_sparm1 === "提供卵子" || egg_sparm1 === "提供精子") {
      $('.select-egg-sparm1').text(egg_sparm1_memo);
      $(".egg_sparm1_default2").show();
      $(".egg_sparm1_default").hide();
    } else {
      $(".egg_sparm1_default2").hide();
      $(".egg_sparm1_default").show();
    }
  });
});

// 用いた卵子と精子の説明②
$(function() {
  eggsperm2($("#report_types_of_eggs_and_sperm_status option:selected").val());
  $("#report_types_of_eggs_and_sperm_status").change(function() {
    eggsperm2($(this).val());
  });
})
function eggsperm2(types_of_eggs_and_sperm_status) {
  if (types_of_eggs_and_sperm_status > "1") {
    $(".description_of_eggs_and_sperm_used_status").show();
  } else {
    $(".description_of_eggs_and_sperm_used_status").hide();
  }
}
// フォーム内の②卵子と精子の回答によって次項のテキストを変える
$(function() {
  var egg_sparm2 = $('#report_types_of_eggs_and_sperm_status option:selected').text();
  var egg_sparm2_memo = egg_sparm2 + "についての詳しい説明";
  if (egg_sparm2 === "凍結卵子" || egg_sparm2 === "凍結精子" || egg_sparm2 === "凍結卵子と凍結精子") {
    $('.select-egg-sparm2').text(egg_sparm2_memo);
    $(".egg_sparm2_default2").show();
    $(".egg_sparm2_default").hide();
  } else {
    $(".egg_sparm2_default2").hide();
    $(".egg_sparm2_default").show();
  }
});
$(function() {
  $('#report_types_of_eggs_and_sperm_status').change(function() {
    var egg_sparm2 = $('#report_types_of_eggs_and_sperm_status option:selected').text();
    var egg_sparm2_memo = egg_sparm2 + "についての詳しい説明";
    if (egg_sparm2 === "凍結卵子" || egg_sparm2 === "凍結精子" || egg_sparm2 === "凍結卵子と凍結精子") {
      $('.select-egg-sparm2').text(egg_sparm2_memo);
      $(".egg_sparm2_default2").show();
      $(".egg_sparm2_default").hide();
    } else {
      $(".egg_sparm2_default2").hide();
      $(".egg_sparm2_default").show();
    }
  });
});

// 受精方法の詳細
$(function() {
  fertilization_method($("#report_types_of_fertilization_methods option:selected").val());
  $("#report_types_of_fertilization_methods").change(function() {
    fertilization_method($(this).val());
  });
})
function fertilization_method(types_of_fertilization_methods) {
  if (types_of_fertilization_methods == "2") {
    $(".detail_of_icsi").show();
    $(".description_of_types_of_fertilization_methods").hide();
  } else if (types_of_fertilization_methods == "3") {
    $(".detail_of_icsi").show();
    $(".description_of_types_of_fertilization_methods").hide();
  } else if (types_of_fertilization_methods == "99") {
    $(".description_of_types_of_fertilization_methods").show();
    $(".detail_of_icsi").hide();
  } else {
    $(".detail_of_icsi").hide();
    $(".description_of_types_of_fertilization_methods").hide();
  }
}

// 顕微受精方法の詳細
$(function() {
  details_of_icsi($("#report_details_of_icsi option:selected").val());
  $("#report_details_of_icsi").change(function() {
    details_of_icsi($(this).val());
  });
})
function details_of_icsi(report_details_of_icsi) {
  if (report_details_of_icsi == "99") {
    $(".description_of_details_of_icsi").show();
  } else  {
    $(".description_of_details_of_icsi").hide();
  }
}


// 治療継続期限
$(function() {
  continue_treatment($("#report_how_long_to_continue_treatment option:selected").val());
  $("#report_how_long_to_continue_treatment").change(function() {
    continue_treatment($(this).val());
  });
})
function continue_treatment(how_long_to_continue_treatment) {
  if (how_long_to_continue_treatment == "1") {
    $(".how_long_to_continue_treatment2").show();
  } else {
    $(".how_long_to_continue_treatment2").hide();
  }
}

// オンライン診療
$(function() {
  online($("#report_online_consultation option:selected").val());
  $("#report_online_consultation").change(function() {
    online($(this).val());
  });
})
function online(online_consultation) {
  if (online_consultation > "1") {
    $(".online_consultation_details").show();
  } else {
    $(".online_consultation_details").hide();
  }
}

// 胚のステージへの移植方法表示(凍結or新鮮胚移植)
$(function() {
  var discription1 = "移植方法は「";
  var discription2 = "」が選択されています。";
  var discription3 = "以降の項目(採卵/移植周期のホルモン値・グレード等)は、「初期胚」か「胚盤胞」のどちらか一方の胚の情報についてのみ選択&入力して下さい。";
  var discription4 = "以降の項目(採卵/移植周期のホルモン値・グレード等)は、2個の胚のうちどちらか一方の胚の情報についてのみ選択&入力して下さい。";
  var val = $('#report_transplant_method').val();
  if (val == "1") {
    var val = "凍結胚移植";
    $('.stage-alert-none').show();
    $('.stage-alert').hide();
    $('.transplant_method').text(val);
    $('.transplant_method_dis1').text(discription1);
    $('.transplant_method_dis2').text(discription2);
  } else if (val == "2") {
    var val = "新鮮胚移植";
    $('.stage-alert-none').show();
    $('.stage-alert').hide();
    $('.transplant_method').text(val);
    $('.transplant_method_dis1').text(discription1);
    $('.transplant_method_dis2').text(discription2);
  } else if (val == "3") {
    var val = "2段階移植(初期胚&胚盤胞)";
    $('.stage-alert-none').hide();
    $('.stage-alert').show();
    $('.transplant_method2').text(val);
    $('.transplant_method_dis3').text(discription1);
    $('.transplant_method_dis4').text(discription2);
    $('.transplant_method_dis5').text(discription3);
  } else if (val == "4") {
    var val = "凍結胚移植(2個戻し)";
    $('.stage-alert-none').hide();
    $('.stage-alert').show();
    $('.transplant_method2').text(val);
    $('.transplant_method_dis3').text(discription1);
    $('.transplant_method_dis4').text(discription2);
    $('.transplant_method_dis5').text(discription4);
  } else {
    $('.stage-alert').hide();
    $('.stage-alert-none').hide();
  }
  $('#report_transplant_method').change(function() {
    var discription1 = "移植方法は「";
    var discription2 = "」が選択されています。";
    var discription3 = "以降の項目(採卵/移植周期のホルモン値・グレード等)は、「初期胚」か「胚盤胞」のどちらか一方の胚の情報についてのみ選択&入力して下さい。";
    var discription4 = "以降の項目(採卵/移植周期のホルモン値・グレード等)は、2個の胚のうちどちらか一方の胚の情報についてのみ選択&入力して下さい。";
    var val = $(this).val();
    if (val == "1") {
      var val = "凍結胚移植";
      $('.stage-alert-none').show();
      $('.stage-alert').hide();
      $('.transplant_method').text(val);
      $('.transplant_method_dis1').text(discription1);
      $('.transplant_method_dis2').text(discription2);
    } else if (val == "2") {
      var val = "新鮮胚移植";
      $('.stage-alert-none').show();
      $('.stage-alert').hide();
      $('.transplant_method').text(val);
      $('.transplant_method_dis1').text(discription1);
      $('.transplant_method_dis2').text(discription2);
    } else if (val == "3") {
      var val = "2段階移植(初期胚&胚盤胞)";
      $('.stage-alert-none').hide();
      $('.stage-alert').show();
      $('.transplant_method2').text(val);
      $('.transplant_method_dis3').text(discription1);
      $('.transplant_method_dis4').text(discription2);
      $('.transplant_method_dis5').text(discription3);
    } else if (val == "4") {
      var val = "凍結胚移植(2個戻し)";
      $('.stage-alert-none').hide();
      $('.stage-alert').show();
      $('.transplant_method2').text(val);
      $('.transplant_method_dis3').text(discription1);
      $('.transplant_method_dis4').text(discription2);
      $('.transplant_method_dis5').text(discription4);
    } else {
      $('.stage-alert').hide();
      $('.stage-alert-none').hide();
    }
  });
});

// 胚のステージ選択
$(function() {
  init($('#report_embryo_stage option:selected').val());
  $("#report_embryo_stage").change(function() {
    init($(this).val());
  });
})
function init(embryo_stage) {
  if (embryo_stage === "1") {
    $(".day_of_shokihaiishoku").show();
    $(".early_embryo_grade").show();
    $(".shokihaiishoku-hormone").show();
    $(".day_of_haibanhoishoku").hide();
    $(".blastocyst_grade1").hide();
    $(".blastocyst_grade2").hide();
    $(".haibanhoishoku-hormone").hide();
  } else if (embryo_stage === "2") {
    $(".day_of_shokihaiishoku").hide();
    $(".early_embryo_grade").hide();
    $(".shokihaiishoku-hormone").hide();
    $(".day_of_haibanhoishoku").show();
    $(".blastocyst_grade1").show();
    $(".blastocyst_grade2").show();
    $(".haibanhoishoku-hormone").show();
  } else {
    $(".day_of_shokihaiishoku").hide();
    $(".early_embryo_grade").hide();
    $(".shokihaiishoku-hormone").hide();
    $(".day_of_haibanhoishoku").hide();
    $(".blastocyst_grade1").hide();
    $(".blastocyst_grade2").hide();
    $(".haibanhoishoku-hormone").hide();
  }
}

// クレジットカードの使用可否
$(function() {
  cost($('#report_credit_card_validity option:selected').val());
  $("#report_credit_card_validity").change(function() {
    cost($(this).val());
  });
})
function cost(credit_card_validity) {
  if (credit_card_validity === "3") {
    $(".amount_that_can_be_activated").show();
  } else {
    $(".amount_that_can_be_activated").hide();
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
}

// 文字数カウント
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