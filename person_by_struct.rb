RUBY_DESCRIPTION # => "ruby 2.2.2p95 (2015-04-13 revision 50295) [x86_64-darwin12.0]"

class Person < Struct.new(:name, :born); end
 
obj = Person.new                # => #<struct Person name=nil, born=nil>
 
obj.class                       # => Person
Person.superclass               # => #<Class:0x007fa71213de48>
 
matz = Person.new('matz')       # => #<struct Person name="matz", born=nil>
 
matz.name                       # => "matz"
 
matz.methods.map(&:to_s).grep(/name/) # => ["name", "name="]
matz.methods.map(&:to_s).grep(/born/) # => ["born", "born="]
 
matz.born = Time.local(1965, 4, 14)
dhh = Person.new('dhh', Time.local(1979, 10, 15))
 
matz.born                       # => 1965-04-14 00:00:00 +0900
dhh.born                        # => 1979-10-15 00:00:00 +0900
 
class Person
  def age
    (Time.now.strftime('%Y%m%d').to_i - born.strftime('%Y%m%d').to_i) / 1_00_00
  end
end
 
matz.age                        # => 50
dhh.age                         # => 35
 
 
matz.to_s                       # => "#<struct Person name=\"matz\", born=1965-04-14 00:00:00 +0900>"
 
class Person
  def to_s
    "#{name}(#{age})"
  end
 
  def inspect; to_s end
end
 
matz.to_s                       # => "matz(50)"
dhh.to_s                        # => "dhh(35)"
 
 
person = Marshal.load(Marshal.dump matz)
 
person == dhh                   # => false
person == matz                  # => true
 
 
person == dhh                   # => false
person == matz                  # => true
 
begin
  matz > dhh                    # => 
rescue
  $!                            # => #<NoMethodError: undefined method `>' for matz(50):Person>
end
 
 
people = [matz, dhh]
 
begin
  people.sort                   # => 
rescue
  $!                            # => #<ArgumentError: comparison of Person with Person failed>
end
 
people.sort_by(&:age)           # => [dhh(35), matz(50)]
people.sort_by{|p| -p.age}      # => [matz(50), dhh(35)]
 
 
h = {matz => "Ruby", dhh => "Rails"}
 
h[matz]                         # => "Ruby"
h[dhh]                          # => "Rails"
 
key = Marshal.load(Marshal.dump matz)
 
key == matz                     # => true
h[key]                          # => "Ruby"
 
matz.hash                       # => -641870977650780375
dhh.hash                        # => -4104542690569051971
key.hash                        # => -641870977650780375
 
 
key.eql? matz                   # => true
key.eql? dhh                    # => false
