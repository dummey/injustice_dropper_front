if RUBY_PLATFORM == 'opal'
  require 'opal-jquery'
end

# By default Volt generates this controller for your Main component
module Main
  class MainController < Volt::ModelController
    def index
      # Add code for when the index view is loaded
    end

    def about
      # Add code for when the about view is loaded
    end

    def court_ready
      return 
#center:new google.maps.LatLng(40.805478,-73.96522499999998),
      `function init_map(){
        var myOptions = {zoom:14,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("gmap_canvas"), myOptions);
        marker = new google.maps.Marker({map: map,position: new google.maps.LatLng(40.805478, -73.96522499999998)});
        infowindow = new google.maps.InfoWindow({content:"<b>The Breslin</b><br/>2880 Broadway<br/> New York" });
        google.maps.event.addListener(marker, "click", function(){
          infowindow.open(map,marker);
        });
        infowindow.open(map,marker);
      }

        //google.maps.event.addDomListener(window, 'load', init_map);
        init_map()
      `
    end

    private

    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    # Determine if the current nav component is the active one by looking
    # at the first part of the url against the href attribute.
    def active_tab?
      url.path.split('/')[1] == attrs.href.split('/')[1]
    end

    def lookup_citation
      #'Access-Control-Allow-Origin' => '*', 
      citation_url = "http://injustice-rest.herokuapp.com/citations/" + page._search1 + ',' + page._search2
      # citation_url = "http://jsonplaceholder.typicode.com/posts"
      HTTP.get(citation_url) do |response|
        page._stuffs = response.json
        page._citations = page._stuffs._citations
      end
    end

    # def address_to_long_lat(address)
    #   address = `encodeURIComponent(address)`
    #   address_url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{address}"
    #   # citation_url = "http://jsonplaceholder.typicode.com/posts"
    #   HTTP.get(address_url, {}) do |response|
    #     page._stuffs = response.json
    #     page._ticket_lat = page._stuffs._results.first._geometry._location._lat
    #     page._ticket_lng = page._stuffs._results.first._geometry._location._lng

    #   end
    # end

    #Court Stuff
    def lookup_court
      court_lookup_url = "http://injustice-rest.herokuapp.com/courts/" + page._court_lookup
      page._court_result = {name: "STL City Court", address: "1520 Market St, St Louis, MO 63103, USA", lat: 38.6282597, lng: -90.20322449999999}
      
      HTTP.get(court_lookup_url) do |response|
        page._stuffs = response.json
        page._stuff = page._stuffs._courts

        key = page._stuff.keys.first
        page._court_result = page._stuff.get(key)

        #making it easier to get to
        page._court_name = key + " Court"
        page._court_lat = page._court_result._lat
        page._court_lng = page._court_result._lng

        #create statistics hash
        page._court_stats = [
          ["Population", page._court_result._total_population, "302148"],
          ["Fines % of GR", page._court_result._fines_percentage_of_gr, "10.5"],
          ["Pop % Below Proverity", page._court_result._demographics_below_poverty_percentage, "12.7"],
        ]

        map_court
      end
    end

    def map_court
      address = `encodeURIComponent(#{page._court_lookup})`
      address_url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{address}"
      # citation_url = "http://jsonplaceholder.typicode.com/posts"
      HTTP.get(address_url) do |response|
        page._stuffs = response.json
        page._ticket_lat = page._stuffs._results.first._geometry._location._lat
        page._ticket_lng = page._stuffs._results.first._geometry._location._lng

        `
          var myOptions = {
            zoom:12,
            center:new google.maps.LatLng(#{page._ticket_lat},#{page._ticket_lng}),
            mapTypeId: google.maps.MapTypeId.ROADMAP
          };
          map = new google.maps.Map(document.getElementById("gmap_canvas"), myOptions);
          marker = new google.maps.Marker({map: map,position: new google.maps.LatLng(#{page._court_lat},#{page._court_lng})});
          infowindow = new google.maps.InfoWindow({content: #{page._court_name.to_s} });
          google.maps.event.addListener(marker, "click", function(){
            infowindow.open(map,marker);
          });
          infowindow.open(map,marker);

          marker2 = new google.maps.Marker({map: map,position: new google.maps.LatLng(#{page._ticket_lat},#{page._ticket_lng})});
          infowindow = new google.maps.InfoWindow({content:"Site of Ticket" });
          google.maps.event.addListener(marker2, "click", function(){
            infowindow.open(map,marker2);
          });
          infowindow.open(map,marker2);

        `
      end
    end

    #warrant stuff
    def lookup_warrant
      page._warrants = [{
        "name" => "A, RACHEL",
        "zip_code" => "14502",
        "date_of_birth" => "03/28/1984",
        "case_number" => "110562986-5"
      }]
    end
  end
end
