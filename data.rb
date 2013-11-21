
# Uni Mannschaft Name Leistungsklasse Riege Geschlecht
add("TUD",1,"Seppl","KM2",1,'m')
add("TUD",1,"Horst","KM3",2,'w')

def add( uni, mannschaft, name, km, riege, geschlecht )
  turner = {
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
  # turner ins array einfuegen
end

def competitors
  [
  ]
end