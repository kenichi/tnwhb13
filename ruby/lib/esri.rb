module Esri

  class AGOClient
    BASE_URL = 'https://arcgis.com/THIS/WONT/WORK'
    CLIENT_ID = 'PUT SOMETHING HERE'
    CLIENT_SECRET = 'PUT SOMETHING HERE'

    def initialize hci = nil
      @hci = hci || HTTPClient.new
      fetch_app_token
    end

    def fetch_app_token
      r = @hci.post BASE_URL + 'oauth2/token',
                    f: 'json',
                    grant_type: 'client_credentials',
                    client_id: CLIENT_ID,
                    client_secret: CLIENT_SECRET
      if r.status == 200
        rh = JSON.parse r.body
        @app_token = rh['access_token']
        @expires_at = Time.at Time.now + rh['expires_in'].to_i
      else
        #...
      end
    end

    def app_token
      fetch_app_token if @expires_at.nil? or @app_token.nil? or Time.now >= @expires_at
      @app_token
    end

  end

  module Geotriggers

    BASE_URL = 'http://geotriggersdev.arcgis.com/'

    class Client

      def initialize
        @hci = HTTPClient.new
        @ago_client = AGOClient.new @hci
      end

      def get method, data = {}
        r = @hci.get BASE_URL + method, data, {
          'Authorization' => "Bearer #{@ago_client.app_token}"
        }
        JSON.parse r.body if r.status == 200
      end

      def post method, data = {}
        r = @hci.post BASE_URL + method, data.to_json, {
          'Authorization' => "Bearer #{@ago_client.app_token}",
          'Content-Type' => 'application/json'
        }
        JSON.parse r.body if r.status == 200
      end

      def create_trigger entry, tags = []
        trigger = entry.to_trigger
        trigger.merge! setTags: tags unless tags.empty?
        post 'trigger/create', trigger
      end

      def add_tag_to_trigger entry_id, tag
        post 'trigger/update', triggerId: entry_id, addTags: tag
      end

      def remove_tag_from_trigger entry_id, tag
        post 'trigger/update', triggerId: entry_id, removeTags: tag
      end

      def delete_trigger entry_id
        post 'trigger/delete', triggerIds: entry_id
      end

      def list_triggers
        get 'trigger/list'
      end

    end

  end

end
