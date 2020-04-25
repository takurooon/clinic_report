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
        data: { city_id: $(this).val() },
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

// 治療の種類選択
// $(function() {
//   ivf($('#report_treatment_type option:selected').val());
//   $("#report_treatment_type").change(function() {
//     ivf($(this).val());
//   });
// })
// function ivf(treatment_type) {
//   if (treatment_type === "1") {
//     $(".number_of_aih").show();
//     $(".advanced_fertility_treatment1").show();
//     $(".advanced_fertility_treatment2").show();
//   } else {
//     $(".number_of_aih").hide();
//     $(".advanced_fertility_treatment1").hide();
//     $(".advanced_fertility_treatment2").hide();
//   }
// }

// 用いた卵子と精子の説明
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

// BMI計算
function calc(){
  var h = Number(document.getElementById("bmi_height").value);
  var w = Number(document.getElementById("bmi_weight").value);
  bmi = Math.round((w / ( (h / 100) * (h / 100) )) * 10);
  bmi = bmi / 10;
  if (isNaN(bmi)) {
    alert("身長と体重を入力してください");
  } else {
    alert("あなたのBMIは" + "「" + bmi + "」です。");
  }
}

// 胚のステージへの移植方法表示(凍結or新鮮胚移植)
$(function() {
  $('#report_transplant_method').change(function() {
    var discription1 = "(移植方法は「";
    var discription2 = "」が選択されています)";
    var val = $(this).val();
    if (val == "1") {
      var val = "凍結胚移植";
      $('.transplant_method').text(val);
      $('.transplant_method_dis1').text(discription1);
      $('.transplant_method_dis2').text(discription2);
    } else if (val == "2") {
      var val = "新鮮胚移植";
      $('.transplant_method').text(val);
      $('.transplant_method_dis1').text(discription1);
      $('.transplant_method_dis2').text(discription2);
    } else {
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

// 保存ボタンを押す時のリマインドアラート
function reportsave() {
  alert("必須項目のクリニックと、お住まい(都道府県&市区町村)は選択されましたか？");
}