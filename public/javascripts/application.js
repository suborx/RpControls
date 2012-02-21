$('document').ready(function(){

  //autocomplete for branches
  $('select.combobox').combobox();

  $('.input-tooltip').tooltip({
    'trigger': 'focus'
  })

  $('a#search').on('click',function(){
    $("form.form-search").slideDown(300);
  })
  $('a.with_popover').popover({
    animation: false,
    placement:'left'});

  $('a.close').click(function(){
    $('div.alert').fadeOut(200);
  });
})
