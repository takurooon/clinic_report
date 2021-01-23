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
  val = $('input[name="report[current_state]"]:checked').val();
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
