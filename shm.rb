require 'sinatra'
require 'json'

set :bind, '0.0.0.0'

class Turner
  def self.add( id, uni, mannschaft, name, km, riege, geschlecht )
    @all ||= []
    @all << {
        :id => id,
        :uni => uni,
        :mannschaft => mannschaft,
        :name => name,
        :km => km,
        :riege => riege,
        :geschlecht => geschlecht,
        :wertungen => { :id=>id }
    }
  end

  def self.load_wertungen
    begin
      data = JSON.parse File.read('wertungen.json')
      @all.each do |tu|
        wertung = data.select{ |d| d['id'].to_i==tu[:id].to_i}.first
        tu[:wertungen] = wertung unless wertung.nil?
      end
    rescue
    end
  end

  def self.save_wertungen
    wertungen = @all.collect {|tu| tu[:wertungen] }
    File.open('wertungen.json', 'w') do |file|
      file.write wertungen.to_json
    end
  end

  def self.find_by_geschlecht geschlecht
    @all.select { |t| t[:geschlecht].include? geschlecht }
  end

  def self.find_by_riege riege
    @all.select { |t| t[:riege] == riege }
  end

  def self.find_by_id id
    @all.select { |t| t[:id]==id }.first
  end

  def self.all
    @all
  end
end

require_relative 'data'

enable :sessions

set :public_folder, File.dirname(__FILE__) + '/static'

helpers do
  def update_turner
    session[:geraet] = @params[:geraet]
    Turner.load_wertungen
    tu = Turner.find_by_id(@params[:turner].to_i)
    unless tu.nil?
      tu[:wertungen][@params[:geraet]] = @params[:wertung].gsub(',','.').to_f
      Turner.save_wertungen
    end
  end

  def bewertung( geschlecht, riege_a, riege_b, geraete )
    erb :bewertung, :layout => :layout, :locals=>{:riege_a=>riege_a, :riege_b=>riege_b, :geraet=>session[:geraet], :geraete=>geraete, :geschlecht=>geschlecht  }
  end
end

get '/' do
  erb :login, :layout => :layout
end

get '/maenner' do
  bewertung( :maenner, 1, 2, %w(Boden Pauschenpferd Ringe Sprung Barren Reck))
end

get '/frauen' do
  bewertung( :frauen, 3, 4, %w(Sprung Stufenbarren Schwebebalken Boden))
end

post '/frauen' do
  update_turner
  redirect '/frauen'
end

post '/maenner' do
  update_turner
  redirect '/maenner'
end

get '/einzelwertungen' do
  turner = Turner.all
  erb :einzelwertungen, :layout => :layout, :locals=>{ :turners=>turner }
end