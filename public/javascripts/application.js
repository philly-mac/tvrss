$(document).ready(function(){
    $.datepicker.setDefaults({
      dateFormat: "yy-mm-dd",
    });

    $("#from_date").datepicker();
    $("#to_date").datepicker();
});
