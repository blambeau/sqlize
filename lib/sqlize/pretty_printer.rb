module SQLize
  class PrettyPrinter

    def accept x
      visit x
    end

    private

    def looks_a_tuple?(a)
      a.is_a?(Hash)
    end

    def looks_a_rel?(a)
      a.is_a?(Array) and a.all?{|x| looks_a_tuple?(x)}
    end

    def colorize(str, x)
      case op = x["__op__"]
      when Marker::DROP
        str.red
      when Marker::CREATE
        str.green
      when Marker::ALTER
        str.yellow
      else 
        str
      end
    end

    def visit x
      if looks_a_rel?(x)
        visit_Rel(x)
      elsif looks_a_tuple?(x)
        visit_Tuple(x)
      elsif x.is_a?(Array)
        visit_Array(x)
      else
        visit_Scalar(x)
      end
    end

    def visit_Rel x
      "- " + x.collect{|tuple|
        visit_Tuple(tuple).gsub(/^/, '  ').strip
      }.join("\n- ")
    end

    def visit_Tuple x
      multi_line = x.values.any?{|v| looks_a_rel?(v)}
      #x = x.select{|k,v| k != "__op__"}
      res = x.collect{|k,v|
        "#{k}:" + (looks_a_rel?(v) ? "\n" : " ") + visit(v)
      }.join(multi_line ? "\n" : ", ")
      multi_line ? res : colorize("{#{res}}", x)
    end

    def visit_Array x
      "[" + x.collect{|x| visit(x)}.join(',') + "]"
    end

    def visit_Scalar x
      x.to_s
    end

  end
end
