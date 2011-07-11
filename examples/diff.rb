$LOAD_PATH.unshift File.expand_path("../../lib",__FILE__) 
require "sqlize"

s1  = YAML.load File.read(File.expand_path("../schema-v1.0.0.yaml", __FILE__))
s2  = YAML.load File.read(File.expand_path("../schema-v1.0.1.yaml", __FILE__))

def conflict
  lambda{|a| a.uniq.size == 1 ? a.first : a}
end

def marker(how)
  if how
    { nil => conflict, "index" => lambda{|a| how} }
  else
    { nil => conflict, "index" => :sum }
  end
end

def merger(how)
  { 
    "relvars" => [[ "name" ], {
      "heading"     => [[ "name" ], marker(how)],
      "constraints" => [[ "name" ], marker(how)]
    }]
  }
end

# this gives all relvars for which something must be done
s1 = [ s1 ].summaryse(merger(-1))
s2 = [ s2 ].summaryse(merger(1))
s = [ s2, s1 ].summaryse(merger(nil))

puts s.to_yaml
