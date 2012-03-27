$('document').ready(function(){

  //autocomplete for branches
  $('select.combobox').combobox();

  $('.input-tooltip').tooltip({
    'trigger': 'focus'
  })

  $('#myModal').modal()

  $('a#search').on('click',function(){
    $("form.form-search").slideDown(300);
  })
  $('a.with_popover').popover({
    animation: false,
    placement:'top'});

  $('a.close').click(function(){
    $('div.alert').fadeOut(200);
  });

  $( "#datepicker" ).datepicker({dateFormat: 'yy-mm-dd'});


  $(getRespondent);

  function getRespondent(){
    $('ul.ui-autocomplete li').live('click', function(){
      current_contact =  $(this).text();
      if ($("select#control_contact option:contains("+current_contact+")")){
        contact_id = $("select#control_contact option:contains("+current_contact+")").val();
      }
      $('#contact').show().load("/contacts/"+contact_id+".js");
    });
  };
})
