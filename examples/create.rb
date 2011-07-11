$LOAD_PATH.unshift File.expand_path("../../lib",__FILE__) 
require "sqlize"

schema  = YAML.load File.read(File.expand_path("../schema-v1.0.0.yaml", __FILE__))
defs = SQLize::Definitions.postgres
puts defs.instantiate("/ddl/schema/create-inline", schema)

