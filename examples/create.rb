$LOAD_PATH.unshift File.expand_path("../../lib",__FILE__) 
require "sqlize"

schema  = YAML.load File.read(File.expand_path("../schema-v1.0.0.yaml", __FILE__))
definitions = SQLize::Definitions.postgres
tpl = definitions.template("/ddl/schema/create-inline")
puts WLang.instantiate(tpl, {:definitions => definitions, :subject => schema}, "sqlize")
