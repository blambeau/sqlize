$LOAD_PATH.unshift File.expand_path("../../lib",__FILE__) 
require "sqlize"

s1  = YAML.load File.read(File.expand_path("../schema-v1.0.0.yaml", __FILE__))
s2  = YAML.load File.read(File.expand_path("../schema-v1.0.1.yaml", __FILE__))
s1 = [s1]
s2 = [s2]

diff = [s2, s1].summaryse(SQLize::Diff)
puts SQLize::PrettyPrinter.new.accept(diff)

