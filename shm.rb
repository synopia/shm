require 'sinatra'
require 'json'

set :bind, '0.0.0.0'

$id = 1

class Turner
  def self.add( uni, mannschaft, name, km, riege, geschlecht )
    @all ||= []
    @all << {
        :id => $id,
        :uni => uni,
        :mannschaft => mannschaft,
        :name => name,
        :km => km,
        :riege => riege,
        :geschlecht => geschlecht,
        :wertungen => {}
    }
    $id = $id + 1
  end
  def self.load_wertungen
    begin
      data = JSON.parse File.read('wertungen.json')
      @all.each do |tu|
        wertung = data.select{ |d| d[:id]==tu[:id]}.first
        tu[:wertungen] = wertung unless wertung.nil?
      end
    rescue
    end

  end
  def self.save_wertungen
    wertungen = @all.collect {|tu| tu[:wertungen].merge({:id=>tu[:id]})}
    File.open('wertungen.json', 'w') do |file|
      file.write wertungen.to_json
    end
  end
  def self.find_by_geschlecht geschlecht
    @all.select do |t|
      t[:geschlecht].include? geschlecht
    end
  end
  def self.find_by_riege riege
    @all.select do |t|
      t[:riege] == riege
    end
  end
  def self.find_by_id id
    @all.select { |t| t[:id]==id }.first
  end


  def self.all
    @all
  end
end


require_relative 'data'

Turner.load_wertungen

enable :sessions

set :public_folder, File.dirname(__FILE__) + '/static'

helpers do
  def update_turner
    session[:geraet] = @params[:geraet]
    tu = Turner.find_by_id(@params[:turner].to_i)
    unless tu.nil?
      tu[:wertungen][@params[:geraet]] = @params[:wertung].to_f
      Turner.save_wertungen
    end
  end
end

get '/' do
  erb :login, :layout => :layout
end

get '/frauen' do
  riege3 = Turner.find_by_riege(3)
  riege4 = Turner.find_by_riege(4)
  puts session[:geraet]
  erb :frauen, :layout => :layout, :locals=>{:riege3=>riege3, :riege4=>riege4, :geraet=>session[:geraet]  }
end

post '/frauen' do
  update_turner
  redirect '/frauen'
end

post '/maenner' do
  update_turner
  redirect '/maenner'
end

get '/maenner' do
  riege1 = Turner.find_by_riege(1)
  riege2 = Turner.find_by_riege(2)

  erb :maenner, :layout => :layout, :locals=>{:riege1=>riege1, :riege2=>riege2, :geraet=>session[:geraet]  }
end

get '/einzelwertungen' do
  turner = Turner.all
  erb :einzelwertungen, :layout => :layout, :locals=>{ :turners=>turner }
end