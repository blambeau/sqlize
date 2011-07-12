module SQLize
  class Diff

    def self.looks_a_rel?(a)
      a.is_a?(Array) and a.all?{|x| x.is_a?(Hash)}
    end

    def self.diff(a)
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
          Summaryse::BYPASS
        elsif left.is_a?(SQLize::Marker)
          left | right
        else
          a
        end
      else
        raise ArgumentError, "Unexpected array #{a.inspect}" if a.size == 2
      end
    end

    def self.to_summaryse
      lambda{|a| diff(a)}
    end

  end
end 
