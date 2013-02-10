require 'stingray/exec/dsl'

describe 'Catalog.Rule', :integration => true do
  include Stingray::Exec::DSL

  it 'should be able to get all rule names' do
    stingray_exec do
      catalog_rule.get_rule_names.should_not be_nil
    end
  end

  it 'should be able to check the syntax of rule text' do
    stingray_exec do
      response = catalog_rule.check_syntax('if ("foo" == "bar") { 1; }')
      response[:results][:item][:valid].should be_true
    end
  end
end
