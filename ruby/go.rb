require 'json'
require 'httpclient'
require 'pry'
require 'pp'

hci = HTTPClient.new

token = "aT3STPnaf3RBOZa6fj1XTHevx-LW87whdYcD-sPz2bBC6MyAF2zOm4qJKQL2xt-ZbPmAv1yLwZti2fLtvCWgDKcZ4_jLvq2oURMzTt0nz7IL0sK7YfLocNA5zSNV9Gj16qQEhF1rdNYraU2oCdFL2g.."

base_url = "http://geotriggersdev.arcgis.com/"

headers = {
  'Authorization' => "Bearer #{token}",
  'Content-Type' => 'application/json'
}

params = {
  previous: {
    latitude: 45.5165,
    longitude: -122.6764,
    accuracy: 10,
    timestamp: (Time.now - 30).iso8601
  },
  locations: [{
    # latitude: 52.52925476346095,
    # longitude: 13.378914150787296,
    latitude: 52.52461599370164,
    longitude: 13.394825712966849,
    accuracy: 10,
    timestamp: Time.now.iso8601
  }]
}

r = hci.post base_url + "location/update", params.to_json, headers
pp JSON.parse r.body

=begin
------------------------+-------------------------+-------------------------------------------------------------------------------------------
      52.52551770844657 |      13.399790738761908 | You are near 'Sophienkirche'
      52.52493015388922 |      13.399210979167947 | You are near 'Gedenkstätte Grosse Hamburger Strasse  (Grosse Hamburger Strasse Memorial)'
      52.52329312851101 |      13.396651632275393 | You are near 'Monbijoupark  (Monbijou Park)'
              52.526007 |               13.407037 | You are near 'Alte and Neue Schönhauser Strasse'
      52.52403497155708 |      13.402171931213388 | You are near 'Hackesche Höfe'
              52.525116 |               13.402402 | You are near 'Sophienstrasse'
      52.52371157239728 |      13.401520771433297 | You are near 'Alter Jüdischer Friedhof  (Old Jewish Cemetery)'
      52.52461599370164 |      13.394825712966849 | You are near 'Centrum Judaicum  (Jewish Centre)'
              52.524766 |      13.393824999999993 | You are near 'Neue Synagoge  (New Synagogue)'
              52.525798 |               13.388878 | You are near 'Oranienburger Strasse'
      52.52183553850993 |      13.385603406082055 | You are near 'Berliner Ensemble'
     52.528780013546616 |      13.384426333660144 | You are near 'Brecht-Weigel-Gedenkstätte  (Brecht-Weigel Memorial)'
      52.52925476346095 |      13.378914150787296 | You are near 'Museum für Naturkunde  (Natural History Museum)'
      52.52831542253396 |      13.372212608889868 | You are near 'Visitors’ checklist'
      52.52384331011034 |      13.388053165676183 | You are near 'Friedrichstadtpalast  (Friedrichstadt Palace)'
      52.52839421807076 |      13.384773559524547 | You are near 'Visitors’ checklist'
      52.52402777699039 |      13.381949838360583 | You are near 'Deutsches Theater'
     52.526839606214644 |      13.375680839256347 | You are near 'Charité'
=end
