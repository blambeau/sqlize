$LOAD_PATH.unshift File.expand_path("../../lib",__FILE__) 
require "sqlize"

def looks_a_rel?(a)
  a.is_a?(Array) and a.all?{|x| x.is_a?(Hash)}
end

Summaryse.register(:diff){|a|
  case a.size
  when 1
    a.first
  when 2
    left, right = a
    if looks_a_rel?(left)
      [(left & right)].summaryse(SQLize::Marker::UNCHANGED) + [ 
        [(left - right)].summaryse(SQLize::Marker::CREATE), 
        [(right - left)].summaryse(SQLize::Marker::DROP)
      ].summaryse(SQLize::Marker::ALTER)
    elsif left == right
      left
    elsif left.is_a?(SQLize::Marker)
      left | right
    else
      a
    end
  else
    raise ArgumentError, "Unexpected array #{a.inspect}" if a.size == 2
  end
}

s1  = YAML.load File.read(File.expand_path("../schema-v1.0.0.yaml", __FILE__))
s2  = YAML.load File.read(File.expand_path("../schema-v1.0.1.yaml", __FILE__))
s1 = [s1]
s2 = [s2]

diff = [s2, s1].summaryse(:diff)
#puts diff.to_yaml
puts SQLize::PrettyPrinter.new.accept(diff)

