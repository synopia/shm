require 'sinatra'

class Turner
  def self.add( uni, mannschaft, name, km, riege, geschlecht )
    @all ||= []
    @all << {
        :uni => uni,
        :mannschaft => mannschaft,
        :name => name,
        :km => km,
        :riege => riege,
        :geschlecht => geschlecht,
        :wertungen => {
            :boden => -1,
            :pauschenpferd => -1,
            :ringe => -1,
            :sprung => -1,
            :barren => -1,
            :reck => -1,
            :stufenbarren => -1,
            :schwebebalken => -1
        }
    }
  end
  def self.find_by_geschlecht geschlecht
    @all.select do |t|
      t[:geschlecht].include? geschlecht
    end
  end


  def self.all
    @all
  end
end


class Kari
  def self.add name, geschlecht
    @all ||= []
    @all << { :name => name, :geschlecht => geschlecht    }
  end

  def self.all
    @all
  end
end


class Geraet
  def self.add name, geschlecht
    @all ||= []
    @all << { :name=>name, :geschlecht=>geschlecht }
  end

  def self.all
    @all
  end
  def self.find_by_geschlecht geschlecht
    @all.select do |g|
      g[:geschlecht].include? geschlecht
    end
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

get '/wertung' do
  kari = login()
  geraete = Geraet.find_by_geschlecht(kari[:geschlecht])
  turner = Turner.find_by_geschlecht(kari[:geschlecht])

  erb :bewerten, :layout => :layout, :locals=>{:kari=>login(), :geraete=> geraete, :turners=>turner }
end

post '/wertung' do
  kari = login()
  puts @params.to_s
  redirect '/wertung'
end