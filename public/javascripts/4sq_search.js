
function fsq_search(latLng, map) {  
  var client_id     = "HMEWANYJXE0U5UDKIYWYAQLFWVABI4TBGMR3MATVJEFKOHZ0"
  var client_secret = "5SQ0UEBC5THYYBDC3OBLGBW4LWPNF0SN3S4TT5JGHJJRNXQX"
  var url = "https://api.foursquare.com/v2/venues/search?ll=" + latLng.toUrlValue() + "&client_id=" + client_id + "&client_secret=" + client_secret
  
  $.getJSON(url, function(data) {
      var items = data["response"]["groups"][0]["items"];
      $("#results_count").html(items.size() + " results");
  });
}

