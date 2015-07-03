RUBY_DESCRIPTION # => "ruby 2.2.2p95 (2015-04-13 revision 50295) [x86_64-darwin12.0]"
 
class Person
  def initialize name, born = nil
    @name, @born = name, born
  end
  attr_reader :name
  attr_accessor :born
 
  def age
    return nil unless @born
    (Time.now.strftime('%Y%m%d').to_i - @born.strftime('%Y%m%d').to_i) / 1_00_00
  end
 
  def to_s
    age ? "#{@name}(#{age})" : @name
  end
 
  def inspect; to_s end
 
  include Comparable
 
  def <=> o
    @name <=> o.name
  end
 
  def hash
    [@name, @born].hash
  end
 
  def eql? o
    [@name, @born].eql? [o.name, o.born]
  end
end
 
 
if $0 == __FILE__
  matz = Person.new('matz')     # => matz
 
  matz.class                    # => Person
  Person.superclass             # => Object
 
  matz.name                     # => "matz"
 
  matz.methods.map(&:to_s).grep(/name/) # => ["name"]
  matz.methods.map(&:to_s).grep(/born/) # => ["born", "born="]
 
  matz.born = Time.local(1965, 4, 14)
  dhh = Person.new('dhh', Time.local(1979, 10, 15))
 
  matz.born                     # => 1965-04-14 00:00:00 +0900
  dhh.born                      # => 1979-10-15 00:00:00 +0900
 
  matz.age                      # => 50
  dhh.age                       # => 35
 
  matz.to_s                     # => "matz(50)"
  dhh.to_s                      # => "dhh(35)"
 
  person = Marshal.load(Marshal.dump matz)
 
  person == dhh                 # => false
  person == matz                # => true
 
  matz > dhh                    # => true
 
  people = [matz, dhh]
 
  people.sort                   # => [dhh(35), matz(50)]
 
 
  people.sort_by(&:age)         # => [dhh(35), matz(50)]
 
  people.sort_by{|p| -p.age}    # => [matz(50), dhh(35)]
 
 
  h = {matz => "Ruby", dhh => "Rails"}
 
  h[matz]                       # => "Ruby"
  h[dhh]                        # => "Rails"
 
  key = Marshal.load(Marshal.dump matz)
 
  key == matz                   # => true
  h[key]                        # => "Ruby"
 
  matz.hash                     # => 2280122641340983802
  dhh.hash                      # => -484742142467407430
  key.hash                      # => 2280122641340983802
 
  key.eql? matz                 # => true
  key.eql? dhh                  # => false
end
