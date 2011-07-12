module SQLize
  class Marker

    def initialize(name)
      @name = name
    end

    def |(other)
      return self  if other == self
      return self  if other == UNCHANGED
      return other if self == UNCHANGED
      ALTER
    end

    def to_summaryse
      [["name"], {nil => :diff, "__op__" => lambda{|a| self}}]
    end

    def to_yaml(opts = {})
      @name.to_yaml(opts)
    end

    def to_s;    @name.to_s;       end
    def inspect; @name.inspect;    end
    def hash;    @name.hash;       end
    def ==(other); other.is_a?(Marker) && other.inspect == inspect; end
    alias :eql? :==
    
    CREATE    = Marker.new(:create)
    DROP      = Marker.new(:drop)
    ALTER     = Marker.new(:alter)
    UNCHANGED = Marker.new(:unchanged)
  end
end
