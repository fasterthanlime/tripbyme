
function trim_items() {
  for(var i in markers) {
    if(markers.hasOwnProperty(i)) {
      markers[i].setMap(null);
      markers.splice(i, 1);
    }
  }
}

function all_venues_search(latLng, map, collect_data) {
  // remove old results and old map markers
  for(var i in markers) {
    if(markers.hasOwnProperty(i)) {
      if(!map.getBounds().contains(markers[i].getPosition())) {
        markers[i].setMap(null);
        markers.splice(i, 1);
        $("#venue_" + i).remove();
      }
    }
  }
  
  //providers = ["gowalla", "foursquare", "eventful"]
  providers = ["foursquare"]
  for(var i in providers) {
    if(providers.hasOwnProperty(i)) {
      // do only with cache first
      venues_search(providers[i], latLng, map, true);
    }
  }
  
  if(collect_data) {
    setTimeout(function() {
      for(var i in providers) {
        if(providers.hasOwnProperty(i)) {
          // then do actual queries to the provider if needed (for additional info)
          venues_search(providers[i], latLng, map, false);
        }
      }
    }, 500);
  }
}

function venues_search(provider, latLng, map, only_cache) {  
  var url = "/" + provider + "/venues?location=" + latLng.toUrlValue() +
    "&sw=" + map.getBounds().getSouthWest().toUrlValue() +
    "&ne=" + map.getBounds().getNorthEast().toUrlValue()
    
  if(only_cache) {
    url = url + "&only_cache=1";
  }
  do_request(url, map);
}
  
function do_request(url, map) {
  $.getJSON(url, function(data) {
      var items = data;
      
      list = $("#result_items ul");
      
      //var tourPlanCoordinates = [];
      
      for(var i in items) {
        if(items.hasOwnProperty(i)) {
          var item = items[i].venue;
          var img_url = "/images/unknown-place-icon.png";
          
          if(item.icon_url != null) {
              img_url = item.icon_url;
          }
          
          var itemLocation = new google.maps.LatLng(item.lat, item.lng);
          
          // add item to item list
          list.append("<li id='venue_" + item.id + "'><h2><img src='" + img_url + "'> " + item.name + "</h2></li>");
          
          // add marker on the map
          if(markers[item.id] == null) {
            markers[item.id] = new google.maps.Marker({
                position: itemLocation,
                map: map, 
                title: item.name,
                icon: img_url,
            });
          }
          
          // add it to our tour (mostly for debug)
          //tourPlanCoordinates.push(itemLocation);
        }
      }
      
      /*
      // Polyline example code:
      var tour = new google.maps.Polyline({
        path: tourPlanCoordinates,
        strokeColor: "#0033FF",
        strokeOpacity: 0.7,
        strokeWeight: 8
      });
      tour.setMap(map);
      */
  });
}

