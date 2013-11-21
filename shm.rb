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

  def self.all
    @all
  end
end

require_relative 'data'

class Kari
  def self.add name
    @all ||= []
    @all << { :name => name }
  end

  def self.all
    @all
  end
end

Kari.add "lisa"
Kari.add "maggy"
Kari.add "bart"
Kari.add "homer"

class Geraet
  def self.add name
    @all ||= []
    @all << { :name=>name }
  end

  def self.all
    @all
  end
end

Geraet.add :boden
Geraet.add :pauschenpferd
Geraet.add :ringe
Geraet.add :sprung
Geraet.add :barren
Geraet.add :reck
Geraet.add :stufenbarren
Geraet.add :schwebebalken

def login
  Kari.all()[@params[:kari].to_i]
end

get '/' do
  erb :login, :locals=>{:karis=>Kari.all}
end

post '/login' do

  erb :bewerten, :locals=>{:kari=>login(), :geraete=>Geraet.all, :turners=>Turner.all }
end