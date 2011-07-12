module SQLize
  class Marker

    attr_reader :operation
    attr_reader :color

    def initialize(operation, color = nil)
      @operation = operation
      @color = color
    end

    def |(other)
      return self  if other == self
      return self  if other == UNCHANGED
      return other if self == UNCHANGED
      ALTER
    end

    def to_summaryse
      @to_sum ||= [["name"], {
        nil => Diff, 
        "__op__" => if operation == :alter
                      lambda{|a| a.summaryse(:union)}
                    else
                      lambda{|a| self}
                    end
      }]
    end

    def to_s;    @operation.to_s;       end
    def inspect; @operation.inspect;    end
    def hash;    @operation.hash;       end
    def ==(other); other.is_a?(Marker) && other.inspect == inspect; end
    alias :eql? :==
    
    CREATE    = Marker.new(:create,    :green)
    DROP      = Marker.new(:drop,      :red)
    ALTER     = Marker.new(:alter,     :yellow)
    UNCHANGED = Marker.new(:unchanged, nil)
  end
end
