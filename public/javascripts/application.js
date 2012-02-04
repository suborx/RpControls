$('document').ready(function(){

  //autocomplete for branches
  $('select.combobox').combobox();

  $('a.with_popover').popover({
    animation: false,
    placement:'left'});

  $('a.close').click(function(){
    $('div.alert').fadeOut(200);
  });
})
