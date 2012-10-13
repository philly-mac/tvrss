//= require date
//= require jquery.min
//= require jquery-ui.min
//= require jquery_ujs
//= require_self

$(document).ready(function() {

  $.datepicker.setDefaults({
    dateFormat: "yy-mm-dd",
  });

  $("#from_date").datepicker();
  $("#to_date").datepicker();

});
