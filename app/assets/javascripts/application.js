//= require date
//= require jquery.min
//= require jquery-ui.min
//= require jquery_ujs
//= require_self

$(document).ready(function() {

  $.datepicker.setDefaults({
    dateFormat: "yy-mm-dd",
  });

  $("body").on('focus', ".datepicker", function(event) {
    event.preventDefault();
    $(this).attr("id","datepicker-" + new Date().toString());
    $('.datepicker').datepicker();
  });
});
