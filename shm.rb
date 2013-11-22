require 'sinatra'

set :bind, '0.0.0.0'

$id = 1

class Turner
  def self.add( uni, mannschaft, name, km, riege, geschlecht, boden=-1, pauschenpferd=-1, ringe=-1, sprung=-1, barren=-1, reck=-1, stufenbarren=-1, schwebebalken=-1 )
    @all ||= []
    @all << {
        :id => $id,
        :uni => uni,
        :mannschaft => mannschaft,
        :name => name,
        :km => km,
        :riege => riege,
        :geschlecht => geschlecht,
        #:wertungen => {
            :boden => boden,
            :pauschenpferd => pauschenpferd,
            :ringe => ringe,
            :sprung => sprung,
            :barren => barren,
            :reck => reck,
            :stufenbarren => -stufenbarren,
            :schwebebalken => schwebebalken
        #}
    }
    $id = $id + 1
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
    @all.each do |t|
      if t[:id] == id
        return t
      end
    end
  end


  def self.all
    @all
  end
end


require_relative 'data'

enable :sessions
def login
  session[:user_id] = @params[:kari].to_i unless @params[:kari].nil?
  Kari.all()[session[:user_id]]
end

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
  erb :login, :layout => :layout, :locals=>{:karis=>Kari.all}
end

post '/login' do
  kari = login()
  if kari.nil?
    redirect '/'
  else
    redirect '/wertung'
  end
end

get '/frauen' do
  riege3 = Turner.find_by_riege(3)
  riege4 = Turner.find_by_riege(4)

  erb :frauen, :layout => :layout, :locals=>{:riege3=>riege3, :riege4=>riege4  }
end

post '/frauen' do
  puts @params.to_s
  tu = Turner.find_by_id(@params[:turner].to_i)
  tu[@params[:geraet].to_sym] = @params[:wertung].to_f
  redirect '/frauen'
end

post '/maenner' do
  puts @params.to_s
  tu = Turner.find_by_id(@params[:turner].to_i)
  tu[@params[:geraet].to_sym] = @params[:wertung].to_f
  redirect '/maenner'
end

get '/maenner' do
  riege1 = Turner.find_by_riege(1)
  riege2 = Turner.find_by_riege(2)

  erb :maenner, :layout => :layout, :locals=>{:riege1=>riege1, :riege2=>riege2  }
end

get '/einzelwertungen' do
  turner = Turner.all
  erb :einzelwertungen, :layout => :layout, :locals=>{ :turners=>turner }
end