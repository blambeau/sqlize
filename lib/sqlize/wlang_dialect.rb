WLang::dialect("sqlize") do
  rules WLang::RuleSet::Basic
  rules WLang::RuleSet::Encoding
  rules WLang::RuleSet::Imperative

  rule '$' do |parser,offset|
    expr, reached = parser.parse(offset, "wlang/hosted")
    value = parser.evaluate(expr)
    result = value.nil? ? "" : value.to_s
    [result, reached]
  end

  rule '*>' do |parser,offset|
    subject, sep, reached = parser.evaluate("subject"), nil, nil
    [subject.collect{|v| 
      scope = {:subject => v}
      expr, reached = parser.branch(:share => :all, :scope => scope){
        parser.parse(offset, "wlang/hosted")
      }
      sep,  reached = parser.parse_block(reached)
      code = parser.evaluate("definitions.template('#{expr}')")
      parser.branch(:template => WLang::template(code, "sqlize"),
                    :offset   => 0,
                    :shared   => :all,
                    :scope    => scope){
        instantiated, forget = parser.instantiate(true)
        instantiated
      }      
    }.join(sep), reached]
  end

  rule '+' do |parser,offset|
    tpl,reached = parser.parse(offset, "wlang/uri")
    vars = {}
    if parser.has_block?(reached)
      vars, reached = parser.parse_block(reached)
      vars = parser.evaluate("{" + vars + "}")
    end
    code = parser.evaluate("definitions.template('#{tpl}')")
    parser.branch(:template => WLang::template(code, "sqlize"),
                  :offset   => 0,
                  :shared   => :all,
                  :scope    => vars){
      instantiated, forget = parser.instantiate(true)
      [instantiated, reached]
    }
  end

end
