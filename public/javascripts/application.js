$('document').ready(function(){

  //autocomplete for branches
  $('select.combobox').combobox();

  $('.input-tooltip').tooltip({
    'trigger': 'focus'
  })
  $('a[rel]=tooltip').tooltip({animation:false})

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
  $(getQuestionsForControl);
  $(getQuestionsForNewQuestion);
  $(getQuestionHtml);

  function getRespondent(){
    $('ul.ui-autocomplete li').live('click', function(){
      current_contact =  $(this).text();
      if ($("select#control_contact option:contains("+current_contact+")")){
        contact_id = $("select#control_contact option:contains("+current_contact+")").val();
      }
      $('#contact').show().load("/contacts_for_control/"+contact_id);
    });
  };


  function getQuestionsForControl(){
    $('#control_user, #control_for_week').next().bind('autocompleteselect', function(event, ui) {

      if (ui.item.option.parentElement.id == 'control_for_week'){
        users = $('#control_user').find('option:selected');
        user = $(users.first()).attr('value');
        control_id = $('form#jobs').attr('action').split('/')[2]
        week_date = ui.item.option.attributes[0].value;
      }else{
        weeks = $('#control_for_week').find('option:selected');
        week_date = $(weeks.first()).attr('value');
        control_id = $('form#jobs').attr('action').split('/')[2]
        user = ui.item.option.attributes[0].value;
      }

      if (user &&  week_date){
        $('#questions').show().load("/questions_for_control/" +control_id+"/"+user+"/"+week_date);
      }
    });
  };

  function getQuestionsForNewQuestion(){
    $('#question_branch, #question_week').next().bind('autocompleteselect', function(event, ui) {

      if (ui.item.option.parentElement.id == 'question_week'){
        branches = $('#question_branch').find('option:selected');
        branch = $(branches.first()).attr('value');
        week_date = ui.item.option.attributes[0].value;
      }else{
        weeks = $('#question_week').find('option:selected');
        week_date = $(weeks.first()).attr('value');
        branch = ui.item.option.attributes[0].value;
      }

      if (branch &&  week_date){
        $('#already_assigned_questions').show().load("/questions_for_questions/"+branch+"/"+week_date);
      }
    });
  };

  function getQuestionHtml(){
    var question_html = "<div class='control-group'>  <label for='question_question' class='control-label'> Otázka </label>  <div class='controls'>  <input type='text' name='question[questions][]' id='question_question'>  </div> </div>"
    $('#add_more_questions').bind('click', function(){
      $('#more_questions').append(question_html);
      return false
    });
  }
})
