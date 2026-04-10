// app/javascript/custom/menu.js

// メニュー操作用の関数を定義
function addMenuEventListener() {
  let hamburger = document.querySelector("#hamburger");
  if (hamburger) {
    hamburger.addEventListener("click", function(event) {
      event.preventDefault();
      let menu = document.querySelector("#navbar-menu");
      menu.classList.toggle("collapse");
    });
  }

  let account = document.querySelector("#account");
  if (account) {
    account.addEventListener("click", function(event) {
      event.preventDefault();
      let menu = document.querySelector("#dropdown-menu");
      menu.classList.toggle("active");
    });
  }
}

// ページが読み込まれた時、およびTurboで遷移した時に実行する
document.addEventListener("turbo:load", addMenuEventListener);