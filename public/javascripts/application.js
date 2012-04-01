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
  $(getQuestions);


  function getRespondent(){
    $('ul.ui-autocomplete li').live('click', function(){
      current_contact =  $(this).text();
      if ($("select#control_contact option:contains("+current_contact+")")){
        contact_id = $("select#control_contact option:contains("+current_contact+")").val();
      }
      $('#contact').show().load("/contacts/"+contact_id+".js");
    });
  };


  function getQuestions(){
    $('#control_user, #control_for_week').next().bind('autocompleteselect', function(event, ui) {
      console.log(ui.option)
      var users = $('#control_user').find('option:selected');
          weeks = $('#control_for_week').find('option:selected');

            user = $(users.first()).attr('value');
            week_date = $(weeks.first()).attr('value');

            if (user &&  week_date){
              $('#questions').show().load("/questions/"+user+"/"+week_date);
            }
    });

    //$("#control_user option:eq(2)").attr("selected", "selected");
    //$("#control_user").change(function() {
      //$(this).next().val($(this).children(':selected').text());
    //});

    //$("#control_for_week option:eq(2)").attr("selected", "selected");
    //$("#control_for_week").change(function() {
      //$(this).next().val($(this).children(':selected').text());
    //});

  };
})
