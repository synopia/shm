@test = [{:id=>1,:name=>"horst"},{:id=>2,:name=>"emil"}]

def suchma(id)
  @test.each do |t|
    if t[:id] == id
      return t
    end
  end
end

puts suchma(2)