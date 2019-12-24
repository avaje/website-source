$(function () {
  showCode();
  // $('.mytabs a').click(function (e) {
  //   e.preventDefault()
  //   $(this).tab('show')
  // });
});

function setLang(lang) {
  //$.sessionStorage.set('lang', lang);
  localStorage.setItem('lang', lang);
  showCodeFor(lang);
}

function showCode() {
  //const e=null!==localStorage.getItem("darkSwitch")
  //  &&"dark"===localStorage.getItem("darkSwitch");
  //var lang = $.sessionStorage.get('lang');
  var lang = localStorage.getItem('lang');
  showCodeFor(lang);
}

function showCodeFor(lang) {
  if (lang === 'kt') {
    $('.code-java').hide();
    $('.code-kt').show();
    $('.kotlinActive').addClass('active');
    $('.javaActive').removeClass('active');
  } else {
    $('.code-kt').hide();
    $('.code-java').show();
    $('.kotlinActive').removeClass('active');
    $('.javaActive').addClass('active');
  }
}
