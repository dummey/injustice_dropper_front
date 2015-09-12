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
      page._citations = [
       {
          "id" => 1,
          "citation_number" => 789674515,
          "citation_date" => "2015-03-09",
          "first_name" => "Wanda                                                                                                                                                                                                   ",
          "last_name" => "Phillips                                                                                                                                                                                                ",
          "date_of_birth" => "1975-12-30",
          "defendant_address" => "0 Erie Road                                                                                                                                                                                             ",
          "defendant_city" => "DES PERES                                                                                                                                                                                               ",
          "defendant_state" => "MO",
          "drivers_license_number" => "O890037612                                                                                                                                                                                              ",
          "court_date" => "2015-11-12",
          "court_location" => "COUNTRY CLUB HILLS                                                                                                                                                                                      ",
          "court_address" => "7422 Eunice Avenue ",
          "violations" => [{name: "hello world"}, {name: "Bye night"}]
        },
        {
          "id" => 2,
          "citation_number" => 513276502,
          "citation_date" => "2015-03-15",
          "first_name" => "Mildred                                                                                                                                                                                                 ",
          "last_name" => "Collins                                                                                                                                                                                                 ",
          "date_of_birth" => "1960-10-31",
          "defendant_address" => "856 Banding Trail                                                                                                                                                                                       ",
          "defendant_city" => "CHESTERFIELD                                                                                                                                                                                            ",
          "defendant_state" => "MO",
          "drivers_license_number" => "",
          "court_date" => "2015-09-16",
          "court_location" => "FLORISSANT                                                                                                                                                                                              ",
          "court_address" => "315 Howdershell Road                                                                                                                                                                                    "
        },
      ]

      #'Access-Control-Allow-Origin' => '*', 
      citation_url = "http://stark-refuge-7404.herokuapp.com/citations"
      # citation_url = "http://jsonplaceholder.typicode.com/posts"
      HTTP.get(citation_url, 
        {'Access-Control-Allow-Origin' => '*', 
          "crossDomain" => true, 
          "dataType" => "jsonp"} ) do |response|

        puts response

      end
    end

    def address_to_long_lat(address)
      address = `encodeURIComponent(address)`
      address_url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{address}"
      # citation_url = "http://jsonplaceholder.typicode.com/posts"
      HTTP.get(address_url, {}) do |response|
        page._stuffs = response.json
        page._ticket_lat = page._stuffs._results.first._geometry._location._lat
        page._ticket_lng = page._stuffs._results.first._geometry._location._lng
      end
    end

    #Court Stuff
    def lookup_court
      page._court_result = {name: "STL City Court", address: "1520 Market St, St Louis, MO 63103, USA", lat: 38.6282597, lng: -90.20322449999999}
      page._court_lat = page._court_result._lat
      page._court_lng = page._court_result._lng

      map_court
    end

    def map_court
      address_to_long_lat(page._court_lookup).then do
        page._ticket_lat
        page._ticket_lng

        `
          var myOptions = {zoom:12,
              center:new google.maps.LatLng(#{page._ticket_lat},#{page._ticket_lng}),
            mapTypeId: google.maps.MapTypeId.ROADMAP
          };
          map = new google.maps.Map(document.getElementById("gmap_canvas"), myOptions);
          marker = new google.maps.Marker({map: map,position: new google.maps.LatLng(#{page._court_lat},#{page._court_lng})});
          infowindow = new google.maps.InfoWindow({content:"#{page._court_result.name}" });
          google.maps.event.addListener(marker, "click", function(){
            infowindow.open(map,marker);
          });
          infowindow.open(map,marker);

          marker2 = new google.maps.Marker({map: map,position: new google.maps.LatLng(#{page._ticket_lat},#{page._ticket_lng})});
          infowindow = new google.maps.InfoWindow({content:"Shit went down here" });
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
