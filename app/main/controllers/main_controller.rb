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

      `function init_map(){
        var myOptions = {zoom:14,
          center:new google.maps.LatLng(40.805478,-73.96522499999998),
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
      page._citation_result = "Loading..."

      page._violations = [
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
          "court_address" => "7422 Eunice Avenue                                                                                                                                                                                      "
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
      HTTP.get(citation_url, {'Access-Control-Allow-Origin' => '*', "crossDomain" => true, "dataType" => "jsonp"}) do |response|
        stuff = response.json
        puts stuff.first['name']
        page._citation_result = stuff.first['name']
        page._citation_number = 12345
        # page._citation_result = stuff.object_id
      end
    end

    #Court Stuff
    def lookup_court
      page._court_result = {name: "The Blah", address: "4240 Duncan Avenue, 2nd Floor St. Louis, MO 63110"}

      map_court
    end

    def map_court
      address = page._court_result._address

      `
        var myOptions = {zoom:14,
          center:new google.maps.LatLng(40.805478,-73.96522499999998),
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("gmap_canvas"), myOptions);
        marker = new google.maps.Marker({map: map,position: new google.maps.LatLng(40.807, -73.96522499999998)});
        infowindow = new google.maps.InfoWindow({content:"<b>The Breslin</b><br/>2880 Broadway<br/> New York" });
        google.maps.event.addListener(marker, "click", function(){
          infowindow.open(map,marker);
        });
        infowindow.open(map,marker);

        marker2 = new google.maps.Marker({map: map,position: new google.maps.LatLng(40.8055, -73.965226)});
        infowindow = new google.maps.InfoWindow({content:"Shit went down here" });
        google.maps.event.addListener(marker2, "click", function(){
          infowindow.open(map,marker2);
        });
        infowindow.open(map,marker2);

      `
    end
  end
end
