module SQLize
  class PrettyPrinter

    def accept x
      @stack = []
      visit x
    end

    private

    def looks_a_tuple?(a)
      a.is_a?(Hash)
    end

    def looks_a_rel?(a)
      a.is_a?(Array) and a.all?{|x| looks_a_tuple?(x)}
    end

    def with_operation(op)
      if op
        @stack.push(op)
        res = yield
        @stack.pop
        res
      else
        yield
      end
    end

    def colorize(str, terminal)
      case @stack.last
        when Marker::ALTER
          terminal ? str.yellow : str
        when Marker::DROP
          str.red
        when Marker::CREATE
          str.green
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
      with_operation(x["__op__"]) do
        multi_line = x.values.any?{|v| looks_a_rel?(v)}
        y = x.select{|k,v| k != "__op__"}
        res = y.collect{|k,v|
          "#{k}:" + (looks_a_rel?(v) ? "\n" : " ") + visit(v)
        }.join(multi_line ? "\n" : ", ")
        res = multi_line ? res : "{#{res}}"
        res = multi_line ? res : colorize(res, !multi_line)
      end
    end

    def visit_Array x
      "[" + x.collect{|x| visit(x)}.join(',') + "]"
    end

    def visit_Scalar x
      x.to_s
    end

  end
end
