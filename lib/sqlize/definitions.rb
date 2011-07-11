module SQLize
  class Definitions

    attr_reader :defs

    def initialize(defs)
      @defs = defs
    end

    def self.load(yaml_file)
      new YAML.load(File.read(yaml_file))
    end

    def self.postgres
      load File.expand_path('../../../definitions/postgres.yaml', __FILE__)
    end

    def template(qname)
      qname.split('/')[1..-1].inject(defs){|m,k| m[k]}
    rescue
      raise ArgumentError, "No such template #{qname}"
    end

    def instantiate(qname, subject) 
      WLang.instantiate(template(qname), 
        {:definitions => self, :subject => subject}, 
        "sqlize")
    end

  end # class Definitions
end # module SQLize
