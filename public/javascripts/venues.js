
function clear_items() {
  for(var i in markers) {
    markers[i].setMap(null);
    $("li#venue_" + i).remove();
  }
  markers = [];
}

function all_venues_search(latLng, map, collect_data) {
  // remove old results and old map markers
  var toSplice = [];
  
  for(var i in markers) {
    if(markers.hasOwnProperty(i)) {
      if(!map.getBounds().contains(markers[i].getPosition())) {
        markers[i].setMap(null);
        $("li#venue_" + i).remove();
        toSplice.push(i);
      }
    }
  }
  
  for(var i in toSplice.reverse()) {
    markers.splice(i, 1);
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
          
          //$("#result_items ul li div input .plus")
          
          // add marker on the map
          if(markers[item.id] == null) {
            // add item to item list
            list.append("<li id='venue_" + item.id + "'><h2><img src='" + img_url + "'> " + item.name +
            "<div class='plusminus'><input class='plus' type='button' value='+'></input><input class='minus' type='button' value='-'></input></div></h2></li>");
            
            markers[item.id] = new google.maps.Marker({
                position: itemLocation,
                map: map,
                title: item.name,
                icon: img_url,
            });
            google.maps.event.addListener(markers[item.id], 'click', (function(ourItem) {
              return function() {
                var itemId = "li#venue_" + ourItem.id;
                $(".ui-selected").removeClass("ui-selected");
                $(itemId).addClass("ui-selected");
                $.smoothScroll({
                  scrollElement: $('#results'),
                  scrollTarget: itemId
                });
                
                updatePlusMinus();
              }
            })(item));
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

