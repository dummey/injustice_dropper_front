if RUBY_PLATFORM == 'opal'
  require 'opal-jquery'
end

# By default Volt generates this controller for your Main component
module Main
  class MainController < Volt::ModelController
    def index
      page._num_active_violation = 1000 * 100 - 31234
      # p ticker
      `window.setInterval(function() {
        #{page._num_active_violation -= 1};
        }, 250)`
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

    #index stuff
    def ticker
      page._num_active_violation -= 1
    end

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

    def average_fine(ticket)
      if page._fines.empty?
        page._fines = {'No Brake Lights' => {'fine_amount' => 99.34558139534883, 'court_cost' => 24.5}, 'No License Plates' => {'fine_amount' => 109.34285714285711, 'court_cost' => 24.5}, 'Improper Passing' => {'fine_amount' => 97.60214285714285, 'court_cost' => 24.5}, 'Failure to Obey Electric Signal' => {'fine_amount' => 104.24874999999997, 'court_cost' => 24.5}, 'Parking in Fire Zone' => {'fine_amount' => 92.1607142857143, 'court_cost' => 24.5}, "No Driver's License" => {'fine_amount' => 90.86808510638296, 'court_cost' => 24.5}, 'Failure to Yield' => {'fine_amount' => 100.02666666666669, 'court_cost' => 24.5}, 'No Insurance [no compliance]' => {'fine_amount' => 109.55645161290323, 'court_cost' => 24.5}, 'No Inspection Sticker' => {'fine_amount' => 115.71372549019605, 'court_cost' => 24.5}, 'Prohibited U-Turn' => {'fine_amount' => 102.67282051282051, 'court_cost' => 24.5}, 'Expired License Plates (Tags)' => {'fine_amount' => 98.47949152542374, 'court_cost' => 24.5}}
      end

      page._fines.get(ticket)
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
      warrant_url = "http://injustice-rest.herokuapp.com/warrants/" + page._warrant_lookup
      # citation_url = "http://jsonplaceholder.typicode.com/posts"
      HTTP.get(warrant_url) do |response|
        page._stuffs = response.json
        page._warrants = page._stuffs._warrants
      end
    end
  end
end
