require File.expand_path('../spec_helper', __FILE__)
module SQLize
  describe Definitions do

    it "should have a postgres class method" do
      d = Definitions.postgres
      d.should be_a(Definitions)
    end 

    describe "template" do
      let(:defs){ Definitions.postgres }
     
      subject{ defs.template(qname) }

      describe "when called on an existing one" do
        let(:qname){ "/ddl/table/create" }
        it{ should =~ /CREATE TABLE/ }
      end

      describe "when called on an unexisting" do
        let(:qname){ "/no-such/one" }
        specify{ lambda{subject}.should raise_error }
      end

    end

  end
end
