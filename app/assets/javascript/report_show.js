// タブ表示
  // $(function(){
  //   activeTag = $('ul.parent-menu').find("li.active a").first();
  //   if (!activeTag) {
  //       activeTag = $('ul.parent-menu').find("li").first().find("a").first();
  //   }
  //   setActive(activeTag);
  //   $(activeTag.attr('href')).addClass('active');

  //   $('ul.child-menu a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
  //       $(e.target).parent().parent().addClass("active");
  //       $(e.target).parent().addClass("active");
  //       $(e.relatedTarget).parent().removeClass("active");
  //   });
  //   $('ul.parent-menu a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
  //       setActive($(e.target));
  //   });

  //   function setActive(targetObj) {
  //       targetMenuId = targetObj.attr("href");
  //       targetTabId = $(targetMenuId).find("li.active a").first().attr("href");
  //       if(!targetTabId){
  //           $(targetMenuId).find("li").first().addClass("active");
  //           targetTabId = $(targetMenuId).find("li").first().find("a").attr("href");
  //       }
  //       $(targetTabId).addClass('active').addClass('in');
  //   }
  // });

// タブ内採卵移植グラフ表示
  window.onload = function() {
    element = document.getElementById("sairanFshLh");
    if (element != null) {
      ctx = element.getContext("2d");
      window.myBar = new Chart(ctx, {
        type: 'bar',
        data: barChartData1,
        options: complexChartOption1
      });
    };
    element = document.getElementById("sairanFshLh_ichiran");
    if (element != null) {
      ctx = element.getContext("2d");
      window.myBar = new Chart(ctx, {
        type: 'bar',
        data: barChartData1,
        options: complexChartOption1
      });
    };
    element = document.getElementById("sairanE2P4");
    if (element != null) {
      ctx = element.getContext("2d"); 
      window.myBar = new Chart(ctx, {
        type: 'bar',
        data: barChartData2,
        options: complexChartOption2
      });
    };
    element = document.getElementById("sairanE2P4_ichiran");
    if (element != null) {
      ctx = element.getContext("2d"); 
      window.myBar = new Chart(ctx, {
        type: 'bar',
        data: barChartData2,
        options: complexChartOption2
      });
    };
    element = document.getElementById("ishokuFshLh");
    if (element != null) {
      ctx = element.getContext("2d");
      window.myBar = new Chart(ctx, {
        type: 'bar',
        data: barChartData3,
        options: complexChartOption3
      });
    };
    element = document.getElementById("ishokuFshLh_ichiran");
    if (element != null) {
      ctx = element.getContext("2d");
      window.myBar = new Chart(ctx, {
        type: 'bar',
        data: barChartData3,
        options: complexChartOption3
      });
    };
    element = document.getElementById("ishokuE2P4");
    if (element != null) {
      ctx = element.getContext("2d");
      window.myBar = new Chart(ctx, {
        type: 'bar',
        data: barChartData4,
        options: complexChartOption4
      });
    };
    element = document.getElementById("ishokuE2P4_ichiran");
    if (element != null) {
      ctx = element.getContext("2d");
      window.myBar = new Chart(ctx, {
        type: 'bar',
        data: barChartData4,
        options: complexChartOption4
      });
    };
    element = document.getElementById("ishokuhcg");
    if (element != null) {
      ctx = element.getContext("2d");
      window.myBar = new Chart(ctx, {
        type: 'bar',
        data: barChartData5,
        options: complexChartOption5
      });
    };
    element = document.getElementById("ishokuhcg_ichiran");
    if (element != null) {
      ctx = element.getContext("2d");
      window.myBar = new Chart(ctx, {
        type: 'bar',
        data: barChartData5,
        options: complexChartOption5
      });
    };
    ctx = document.getElementById("clinicEvaluation");
    window.clinicEvaluation = new Chart(ctx, {
      type: 'radar',
      data: radarChartData,
      options: {
        maintainAspectRatio: false,
        scale: {
          ticks: {
            label: false,
            min: 0,
            max: 5,
            fixedStepSize: 2,
            showLabelBackdrop: false,
            fontSize: 0,
            color: '#eee',
            drawOnChartArea: true,
          }
        }
      }
    });
    ctx = document.getElementById("clinicEvaluation_ichiran");
    window.clinicEvaluation = new Chart(ctx, {
      type: 'radar',
      data: radarChartData,
      options: {
        maintainAspectRatio: false,
        scale: {
          ticks: {
            label: false,
            min: 0,
            max: 5,
            fixedStepSize: 2,
            showLabelBackdrop: false,
            fontSize: 0,
            color: '#eee',
            drawOnChartArea: true,
          }
        }
      }
    });
  };
  var barChartData1 = {
    labels: gon.sairan_hormones_day,
    datasets: [
      {
        type: 'line',
        label: 'FSH',
        data: gon.sairan_hormones_fsh,
        borderColor : "rgba(54,164,235,0.8)",
        pointBackgroundColor: "rgba(54,164,235,1)",
        fill: false,
        spanGaps: true,
        yAxisID: "y-axis-1",
      },
      {
        type: 'line',
        label: 'LH',
        data: gon.sairan_hormones_lh,
        borderColor : "rgba(255,235,59,1)",
        pointBackgroundColor: "rgba(255,235,59,1)",
        fill: false,
        spanGaps: true,
        yAxisID: "y-axis-2",
      },
    ],
  };
  var complexChartOption1 = {
    responsive: true,
    scales: {
      yAxes: [{
        id: "y-axis-1",
        type: "linear", 
        position: "left",
        ticks: {
          min: 0
        },
      }, 
      {
        id: "y-axis-2",
        type: "linear", 
        position: "right",
        ticks: {
          min: 0
        },
        gridLines: {
          drawOnChartArea: false, 
        },
      }],
    }
  };
  var barChartData2 = {
    labels: gon.sairan_hormones_day,
    datasets: [
      {
        type: 'line',
        label: 'E2',
        data: gon.sairan_hormones_e2,
        borderColor : "rgba(254,97,132,0.7)",
        pointBackgroundColor: "rgba(254,97,132,1)",
        fill: false,
        spanGaps: true,
        yAxisID: "y-axis-1",
      },
      {
        type: 'line',
        label: 'P4',
        data: gon.sairan_hormones_p4,
        borderColor: "rgba(0,188,212,0.6)",
        pointBackgroundColor: "rgba(0,188,212,1)",
        fill: false,
        spanGaps: true,
        yAxisID: "y-axis-2",
      },
    ],
  };
  var complexChartOption2 = {
    responsive: true,
    scales: {
      yAxes: [{
        id: "y-axis-1",
        type: "linear", 
        position: "left",
        ticks: {
          min: 0
        },
      }, 
      {
        id: "y-axis-2",
        type: "linear", 
        position: "right",
        ticks: {
          min: 0
        },
        gridLines: {
          drawOnChartArea: false, 
        },
      }],
    }
  };

  var barChartData3 = {
    labels: gon.labels,
    datasets: [
      {
        type: 'line',
        label: 'FSH',
        data: gon.ishoku_hormones_fsh,
        borderColor : "rgba(54,164,235,0.8)",
        pointBackgroundColor: "rgba(54,164,235,1)",
        fill: false,
        spanGaps: true,
        yAxisID: "y-axis-1",
      },
      {
        type: 'line',
        label: 'LH',
        data: gon.ishoku_hormones_lh,
        borderColor : "rgba(255,235,59,1)",
        pointBackgroundColor: "rgba(255,235,59,1)",
        fill: false,
        spanGaps: true,
        yAxisID: "y-axis-2",
      },
    ],
  };
  var complexChartOption3 = {
    responsive: true,
    scales: {
      yAxes: [{
        id: "y-axis-1",
        type: "linear", 
        position: "left",
        ticks: {
          min: 0
        },
      }, 
      {
        id: "y-axis-2",
        type: "linear", 
        position: "right",
        ticks: {
          min: 0
        },
        gridLines: {
          drawOnChartArea: false, 
        },
      }],
    }
  };

  var barChartData4 = {
    labels: gon.labels,
    datasets: [
      {
        type: 'line',
        label: 'E2',
        data: gon.ishoku_hormones_e2,
        borderColor : "rgba(254,97,132,0.7)",
        pointBackgroundColor: "rgba(254,97,132,1)",
        fill: false,
        spanGaps: true,
        yAxisID: "y-axis-1",
      },
      {
        type: 'line',
        label: 'P4',
        data: gon.ishoku_hormones_p4,
        borderColor: "rgba(0,188,212,0.6)",
        pointBackgroundColor: "rgba(0,188,212,1)",
        fill: false,
        spanGaps: true,
        yAxisID: "y-axis-2",
      },
    ],
  };
  var complexChartOption4 = {
    responsive: true,
    scales: {
      yAxes: [{
        id: "y-axis-1",
        type: "linear", 
        position: "left",
        ticks: {
          min: 0
        },
      }, 
      {
        id: "y-axis-2",
        type: "linear", 
        position: "right",
        ticks: {
          min: 0
        },
        gridLines: {
          drawOnChartArea: false, 
        },
      }],
    }
  };

  var barChartData5 = {
    labels: gon.ishoku_hormones_et_bt,
    datasets: [
      {
        type: 'line',
        label: 'hCG',
        data: gon.ishoku_hormones_hcg,
        borderColor : "rgba(117,117,117,0.7)",
        pointBackgroundColor: "rgba(117,117,117,1)",
        fill: false,
        spanGaps: true,
        yAxisID: "y-axis-1",
      },
    ],
  };
  var complexChartOption5 = {
    responsive: true,
    scales: {
      yAxes: [{
        id: "y-axis-1",
        type: "linear", 
        position: "right",
        ticks: {
          min: 0
        },
      }],
    }
  };
  var radarChartData = {
    labels:  ["医師", "スタッフ", "技術", "価格", "待ち時間", "院内環境"],
    datasets: [
      {
        type: 'radar',
        label: gon.clinic_name,
        data: gon.clinic_evaluation,
        borderColor : "rgb(117,215,229)",
        pointBackgroundColor: "rgba(54,164,235,1)",
        borderWidth: 3,
        backgroundColor: "rgba(117,215,229,0.1)",
        hitRadius: 10,
      },
    ],
  };

  // コピーボタン
  document.getElementById("copy-page").onclick = function() {
    $(document.body).append("<textarea id=\"copyTarget\" style=\"position:absolute; left:-9999px; top:0px;\" readonly=\"readonly\">" +location.href+ "</textarea>");
    let obj = document.getElementById("copyTarget");
    let range = document.createRange();
    range.selectNode(obj);
    window.getSelection().addRange(range);
    document.execCommand('copy');
  };
  document.getElementById("copy-page2").onclick = function() {
    $(document.body).append("<textarea id=\"copyTarget\" style=\"position:absolute; left:-9999px; top:0px;\" readonly=\"readonly\">" +location.href+ "</textarea>");
    let obj2 = document.getElementById("copyTarget");
    let range2 = document.createRange();
    range2.selectNode(obj2);
    window.getSelection().addRange(range2);
    document.execCommand('copy');
  };


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

// コメント欄へのページ内リンク
$(function(){
  $('a[href^="#comments_area"]').click(function(){
    var adjust = 50;
    var speed = 500;
    var href= $(this).attr("href");
    var target = $(href == "#" || href == "" ? 'html' : href);
    var position = target.offset().top - adjust;
    $("html, body").animate({scrollTop:position}, speed, "swing");
    return false;
  });
});