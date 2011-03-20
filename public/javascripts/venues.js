
function all_venues_search(latLng, map) {
  console.log("Doing all_venues_search");
  $("#result_items ul").html("");
  
  providers = ["gowalla", "foursquare", "eventful"]
  for(i in providers) {
    if(providers.hasOwnProperty(i)) {
      venues_search(providers[i], latLng, map);
    }
  }
}

function venues_search(provider, latLng, map) {  
  var url = "/" + provider + "/venues?location=" + latLng.toUrlValue()
  // do only with cache first
  do_request(url + "&only_cache=1", map);
  // then do actual queries to the provider if needed (for additional info)
  do_request(url, map);
}
  
function do_request(url, map) {
  $.getJSON(url, function(data) {
      var items = data;
      
      list = $("#result_items ul");
      
      var tourPlanCoordinates = new Array();
      
      for(var i in items) {
        if(items.hasOwnProperty(i)) {
          var item = items[i].venue;
          var img_url = "/images/unknown-place-icon.png";
          
          /*
          if(item.categories.hasOwnProperty(0)) {
              img_url = item.categories[0].icon;
          }
          */
          
          var itemLocation = new google.maps.LatLng(item.lat, item.lng);
          
          // add item to item list
          list.append("<li><h2><img src='" + img_url + "'> " + item.name + "</h2></li>");
          
          // add marker on the map
          markers[item.id] = new google.maps.Marker({
              position: itemLocation,
              map: map, 
              title: item.name,
              icon: img_url,
          });
          
          // add it to our tour (mostly for debug)
          tourPlanCoordinates.push(itemLocation);
        }
      }
      
      var tour = new google.maps.Polyline({
        path: tourPlanCoordinates,
        strokeColor: "#0033FF",
        strokeOpacity: 0.7,
        strokeWeight: 8
      });
      //tour.setMap(map);
  });
}

