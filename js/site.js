$(function () {
  init();
  $('.code.nav-tabs a').click(function (e) {
    e.preventDefault()
    $(this).tab('show')
  });
  $('#toggleTheme').click(function (e) {
    e.preventDefault()
    toggleTheme();
  });
});
function init() {
  setTheme(localStorage.getItem('theme'));
  showCodeLang(localStorage.getItem('lang'));
}
function setLang(lang) {
  localStorage.setItem('lang', lang);
  showCodeLang(lang);
}

function toggleTheme() {
  const theme = localStorage.getItem('theme') === 'dark' ? 'light' : 'dark';
  localStorage.setItem('theme', theme);
  setTheme(theme);
}
function setTheme(theme) {
  if (theme === 'dark') {
    document.body.setAttribute("data-theme","dark");
  } else {
    document.body.setAttribute("data-theme","light")
  }
}
function showCodeLang(lang) {
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
