jQuery(function($) {
  $(document).ready(function() {

    if ($('#longitude').length > 0) {
      if ("geolocation" in navigator) {
        navigator.geolocation.getCurrentPosition(function(position) {
          $('#longitude').val(position.coords.longitude);
          $('#latitude').val(position.coords.latitude);
        });
      }
    }

  });
});
