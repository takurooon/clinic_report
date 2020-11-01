// 戻るボタンを無効化
history.pushState(null, null, location.href);
window.addEventListener('popstate', (e) => {
  history.go(1);
});

// ブラウザが閉じるorリロードする時にアラート発動(https://qiita.com/naoki_koreeda/items/bf0f512dbd91b450c671)これを有効にした場合、以下の特定ボタン押下(createまたはupdateボタン)後にもアラートが出る。要改善。
// $(function(){
//   var unloaded = function (e) {
//     // カスタムメッセージの設定（後述するが、EdgeとIEしか表示されない）
//     var confirmMessage = '【注意！】ページを離れますか？投稿/更新/保存のいずれかを行わずにページを離れると選択したデータや入力したデータは保存されず消えてしまいます。ご注意ください。';
//     e.returnValue = confirmMessage;
//     return confirmMessage;
//   };
//     // beforeunloadイベントの登録
//     window.addEventListener('beforeunload', unloaded, false);

//     // 特定のボタンがクリックされたときはアラートを表示しないようにもできます。
//     document.getElementById('submit-bottun-update').addEventListener('click', function(){
//       // submit時はアラート表示させない
//       window.removeEventListener('beforeunload', unloaded, false);
//     });
// });