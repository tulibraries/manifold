  $(function () {
      // console.log("Button loaded");
      $('#select_all').click(function() {
          // console.log("Button clicked");
          $('#service_intended_audience option').prop('selected', true);
      });
  });
