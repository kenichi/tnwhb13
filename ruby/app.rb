class App < Sinatra::Base

  configure do
    set :root, Turmeric::ROOT
    if development?
      enable :reload_templates
      use Rack::ColorizedLogger do |logger|
        logger.public = 'public'
      end
    else
      use Rack::CommonLogger unless test?
    end
  end

  helpers do
    def options_for_select(a, selected = nil)
      a.map {|opt|
        %{<option value="#{opt[0]}" #{selected="selected" if opt[0].to_s == selected.to_s}>#{opt[1]}</option>}
      }.join("\n")
    end
  end

  get '/?' do
    erb :index
  end

  get '/entries/?' do
    set_entries
    erb :entries
  end

  get '/entries.json' do
    set_entries
    create_triggers if params['create_triggers'] == "true"
    content_type :json
    @entries.to_json
  end

  def set_entries
    Pearson::API.guidebook = params['guidebook'] if params['guidebook']
    @entries = Pearson::API.entries_for lat: params['latitude'], lon: params['longitude']
  end

  def create_triggers tag = 'berlin'
    gts = Esri::Geotriggers::Client.new

    existing_triggers_ids = gts.get('trigger/list')['triggers'].map {|t| t['triggerId']}

    @entries.each do |e|
      unless existing_triggers_ids.include? e.id
        gts.post 'trigger/create', e.to_trigger.merge(setTags: [tag])
      end
    end
  end

end
