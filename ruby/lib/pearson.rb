module Pearson

  Cache = Redis.new database: 0

  class APIClient

    BASE_URL = 'https://api.pearson.com/'

    attr_accessor :api_key

    def initialize api_key = ''
      @hci = HTTPClient.new
      @api_key = api_key
    end

    def url
      BASE_URL
    end

    def get path = '', opts = {}
      cache_key = OpenSSL::Digest::SHA.hexdigest url(path) + opts.keys.sort.join('') + opts.values.sort.join('')
      if r = Pearson::Cache.get(cache_key)
        JSON.parse r
      else
        r = @hci.get url(path), opts.merge(apikey: @api_key)
        if r.status == 200
          Pearson::Cache.set cache_key, r.body
          Pearson::Cache.expire cache_key, 86400
          JSON.parse r.body
        else
          #...
        end
      end
    end

  end

  module Eyewitness

    class APIClient < APIClient

      BASE_URL = APIClient::BASE_URL + 'eyewitness/'
      GUIDEBOOKS = %w[
        london
        newyork
        paris
        washington
        berlin
        rome
        barcelona
        venice
        prague
      ]

      attr_reader :guidebook

      def initialize api_key = '', guidebook = 'berlin'
        raise ArgumentError unless GUIDEBOOKS.include? guidebook
        super api_key
        @guidebook = guidebook
      end

      def url path = ''
        BASE_URL + @guidebook + path
      end

      def entries_for opts = {}
        r = get '/block.json', opts
        r['list']['link'].map {|e| Entry.from_api entry_for(e['@id'])} if r['list'] and r['list']['link']
      end

      def entry_for id
        r = get "/block/#{id}.json"
      end

      def guidebook= _guidebook = 'berlin'
        @guidebook = _guidebook.downcase.gsub(/\s+/, '')
      end

    end

    class Entry

      DEFAULT_TRIGGER_SIZE = 100

      attr_accessor :id,
                    :latitude,
                    :longitude,
                    :title,
                    :category,
                    :phone

      def self.from_api data
        e = Entry.new
        data = data['block']
        e.id = data['tg_info']['@id']
        e.latitude = Float(data['tg_info']['@lat'])
        e.longitude = Float(data['tg_info']['@long'])
        e.title = data['title']['#text']
        e.category = data['tg_info']['info']['category']['#text'] if data['tg_info']['info']['category']
        e.phone = data['tg_info']['phone']['#text'] if data['tg_info']['phone']
        e.title.gsub! /\s*\(.*\)\s*/, ''
        e
      end

      def to_trigger trigger_size = DEFAULT_TRIGGER_SIZE
        {
          triggerId: self.id,
          condition: {
            direction: 'enter',
            geo: {
              latitude: self.latitude,
              longitude: self.longitude,
              distance: trigger_size
            }
          },
          action: {
            message: "You are near '#{self.title}'"
          }
        }
      end

      def to_json(*args)
        {
          "id" => self.id,
          "title" => self.title,
          "latitude" => self.latitude,
          "longitude" => self.longitude,
          "phone" => self.phone
        }.to_json
      end

    end

  end

  API = Pearson::Eyewitness::APIClient.new 'PUT SOMETHING HERE'

end
