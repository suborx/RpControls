$('document').ready(function(){

  //autocomplete for branches
  $('select.combobox').combobox();

  $('a.with_popover').popover({
    animation: false,
    placement:'left'});
})
