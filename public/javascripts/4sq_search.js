
function fsq_search(latLng, map) {  
  var client_id     = "HMEWANYJXE0U5UDKIYWYAQLFWVABI4TBGMR3MATVJEFKOHZ0"
  var client_secret = "5SQ0UEBC5THYYBDC3OBLGBW4LWPNF0SN3S4TT5JGHJJRNXQX"
  var url = "https://api.foursquare.com/v2/venues/search?ll=" + latLng.toUrlValue() + "&client_id=" + client_id + "&client_secret=" + client_secret
  
  $.getJSON(url, function(data) {
      var items = data.response.groups[0].items;
      $("#result_count").html(items.length + " results");
      
      list = $("#result_items ul");
      list.html("");
      
      for(var i in items) {
        if(items.hasOwnProperty(i)) {
          var item = items[i];
          var img_url = "/images/unknown-place-icon.png";
          if(item.categories.hasOwnProperty(0)) {
              img_url = item.categories[0].icon;
          }
          list.append("<li><h2><img src='" + img_url + "'> " + item.name + "</h2></li>");
        }
      }
  });
}

