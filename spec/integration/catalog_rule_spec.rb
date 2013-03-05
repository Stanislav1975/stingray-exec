require 'stingray/exec/dsl'

describe 'Catalog.Rule', :integration => true do
  include Stingray::Exec::DSL

  def test_rule_name
    @test_rule_name ||= "test-rule-#{rand(999)}-#{Time.now.to_i}"
  end

  after :all do
    stingray_exec do
      begin
        catalog_rule.delete_rule(test_rule_name)
      rescue
        # derp.
      end
    end
  end

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

  it 'should not be able to add new rules for reasons unknown' do
    expect do
      stingray_exec do
        catalog_rule.add_rule(test_rule_name => [
          %Q@if (http.getheader("Host") == "dev.null") {\n    pool.use("discard");\n}@
        ])
      end
    end.to raise_error

    # XXX some debug output from failure in action:
    # [1] stingray-exec(main)> catalog_rule.get_rule_names
    # D, [2013-02-13T22:49:26.088638 #79858] DEBUG -- : SOAP request: https://admin:admin@192.168.1.8:9090/soap
    # D, [2013-02-13T22:49:26.089951 #79858] DEBUG -- : SOAPAction: "getRuleNames", Content-Type: text/xml;charset=UTF-8, Content-Length: 337
    # D, [2013-02-13T22:49:26.089995 #79858] DEBUG -- : <?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:wsdl="http://soap.zeus.com/zxtm/1.0/Catalog/Rule/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"><env:Body><wsdl:getRuleNames></wsdl:getRuleNames></env:Body></env:Envelope>
    # W, [2013-02-13T22:49:26.109771 #79858]  WARN -- : HTTPI executes HTTP POST using the net_http adapter
    # D, [2013-02-13T22:49:26.218769 #79858] DEBUG -- : SOAP response (status 200):
    # D, [2013-02-13T22:49:26.218871 #79858] DEBUG -- : <?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:namesp1="http://soap.zeus.com/zxtm/1.0/Catalog/Rule/" xmlns:zeusns_1_1="http://soap.zeus.com/zxtm/1.1/" xmlns:zeusns_1_2="http://soap.zeus.com/zxtm/1.2/" soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:zeusns="http://soap.zeus.com/zxtm/1.0/" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><namesp1:getRuleNamesResponse><names soapenc:arrayType="xsd:string[2]" xsi:type="soapenc:Array"><Item xsi:type="xsd:string">foo_host</Item><Item xsi:type="xsd:string">foo_host2</Item></names></namesp1:getRuleNamesResponse></soap:Body></soap:Envelope>
    # => {:names=>
    #   {:item=>["foo_host", "foo_host2"],
    #    :"@soapenc:array_type"=>"xsd:string[2]",
    #    :"@xsi:type"=>"soapenc:Array"}}
    # [2] stingray-exec(main)> catalog_rule.get_rule_details('foo_host')
    # D, [2013-02-13T22:49:56.329022 #79858] DEBUG -- : SOAP request: https://admin:admin@192.168.1.8:9090/soap
    # D, [2013-02-13T22:49:56.329106 #79858] DEBUG -- : SOAPAction: "getRuleDetails", Content-Type: text/xml;charset=UTF-8, Content-Length: 489
    # D, [2013-02-13T22:49:56.329143 #79858] DEBUG -- : <?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:Catalog.Rule="http://soap.zeus.com/zxtm/1.0/Catalog/Rule/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"><env:Body><Catalog.Rule:getRuleDetails><names soapenc:arrayType="xsd:string[1]"><s0>foo_host</s0></names></Catalog.Rule:getRuleDetails></env:Body></env:Envelope>
    # W, [2013-02-13T22:49:56.329191 #79858]  WARN -- : HTTPI executes HTTP POST using the net_http adapter
    # D, [2013-02-13T22:49:56.389574 #79858] DEBUG -- : SOAP response (status 200):
    # D, [2013-02-13T22:49:56.389672 #79858] DEBUG -- : <?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:namesp1="http://soap.zeus.com/zxtm/1.0/Catalog/Rule/" xmlns:zeusns_1_1="http://soap.zeus.com/zxtm/1.1/" xmlns:zeusns_1_2="http://soap.zeus.com/zxtm/1.2/" soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:zeusns="http://soap.zeus.com/zxtm/1.0/" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><namesp1:getRuleDetailsResponse><info soapenc:arrayType="zeusns:Catalog.Rule.RuleInfo[1]" xsi:type="soapenc:Array"><Item xsi:type="zeusns:Catalog.Rule.RuleInfo"><rule_text xsi:type="xsd:string">
    # if( http.getheader( "Host" ) == "foo.local" ){
    #
    #         pool.use( "foo" );
    #
    # }
    # </rule_text><rule_notes xsi:type="xsd:string" /></Item></info></namesp1:getRuleDetailsResponse></soap:Body></soap:Envelope>
    # => {:info=>
    #   {:item=>
    #     {:rule_text=>
    #       "\nif( http.getheader( \"Host\" ) == \"foo.local\" ){\n\n\tpool.use( \"foo\" );\n\n}\n",
    #      :rule_notes=>{:"@xsi:type"=>"xsd:string"},
    #      :"@xsi:type"=>"zeusns:Catalog.Rule.RuleInfo"},
    #    :"@soapenc:array_type"=>"zeusns:Catalog.Rule.RuleInfo[1]",
    #    :"@xsi:type"=>"soapenc:Array"}}
    # [3] stingray-exec(main)> foo_host_rule = _[:info][:item][:rule_text]
    # => "\nif( http.getheader( \"Host\" ) == \"foo.local\" ){\n\n\tpool.use( \"foo\" );\n\n}\n"
    # [4] stingray-exec(main)> catalog_rule.add_rule('foo_host3' => [foo_host_rule])
    # D, [2013-02-13T22:50:48.306876 #79858] DEBUG -- : SOAP request: https://admin:admin@192.168.1.8:9090/soap
    # D, [2013-02-13T22:50:48.306988 #79858] DEBUG -- : SOAPAction: "addRule", Content-Type: text/xml;charset=UTF-8, Content-Length: 683
    # D, [2013-02-13T22:50:48.307050 #79858] DEBUG -- : <?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:Catalog.Rule="http://soap.zeus.com/zxtm/1.0/Catalog/Rule/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"><env:Body><Catalog.Rule:addRule><names soapenc:arrayType="xsd:string[1]"><k0>foo_host3</k0></names><texts soapenc:arrayType="xsd:list[1]"><k0 soapenc:arrayType="xsd:string[1]"><node0>
    # if( http.getheader( &quot;Host&quot; ) == &quot;foo.local&quot; ){
    #
    #         pool.use( &quot;foo&quot; );
    #
    # }
    # </node0></k0></texts></Catalog.Rule:addRule></env:Body></env:Envelope>
    # W, [2013-02-13T22:50:48.307128 #79858]  WARN -- : HTTPI executes HTTP POST using the net_http adapter
    # D, [2013-02-13T22:50:48.488328 #79858] DEBUG -- : SOAP response (status 500):
    # D, [2013-02-13T22:50:48.488425 #79858] DEBUG -- : <?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:namesp1="http://soap.zeus.com/zxtm/1.0/Catalog/Rule/" xmlns:zeusns_1_1="http://soap.zeus.com/zxtm/1.1/" xmlns:zeusns_1_2="http://soap.zeus.com/zxtm/1.2/" soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:zeusns="http://soap.zeus.com/zxtm/1.0/" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><soap:Fault><faultcode>soap:Client</faultcode><faultstring>Error: line 1: syntax error, unexpected '=', expecting '('
    # Compilation of rule 'foo_host3' failed, with 1 error</faultstring></soap:Fault></soap:Body></soap:Envelope>
    # Savon::SOAP::Fault: (soap:Client) Error: line 1: syntax error, unexpected '=', expecting '('
    # Compilation of rule 'foo_host3' failed, with 1 error
    # from /Users/d.buch/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/savon-1.2.0/lib/savon/soap/response.rb:107:in `raise_errors'
    # [5] stingray-exec(main)> catalog_rule.check_syntax(foo_host_rule)
    # D, [2013-02-13T22:51:13.719464 #79858] DEBUG -- : SOAP request: https://admin:admin@192.168.1.8:9090/soap
    # D, [2013-02-13T22:51:13.719546 #79858] DEBUG -- : SOAPAction: "checkSyntax", Content-Type: text/xml;charset=UTF-8, Content-Length: 583
    # D, [2013-02-13T22:51:13.719582 #79858] DEBUG -- : <?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:Catalog.Rule="http://soap.zeus.com/zxtm/1.0/Catalog/Rule/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"><env:Body><Catalog.Rule:checkSyntax><ruleText soapenc:arrayType="xsd:string[1]"><s0>
    # if( http.getheader( &quot;Host&quot; ) == &quot;foo.local&quot; ){
    #
    #         pool.use( &quot;foo&quot; );
    #
    # }
    # </s0></ruleText></Catalog.Rule:checkSyntax></env:Body></env:Envelope>
    # W, [2013-02-13T22:51:13.719629 #79858]  WARN -- : HTTPI executes HTTP POST using the net_http adapter
    # D, [2013-02-13T22:51:13.836153 #79858] DEBUG -- : SOAP response (status 200):
    # D, [2013-02-13T22:51:13.836242 #79858] DEBUG -- : <?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:namesp1="http://soap.zeus.com/zxtm/1.0/Catalog/Rule/" xmlns:zeusns_1_1="http://soap.zeus.com/zxtm/1.1/" xmlns:zeusns_1_2="http://soap.zeus.com/zxtm/1.2/" soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:zeusns="http://soap.zeus.com/zxtm/1.0/" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><namesp1:checkSyntaxResponse><results soapenc:arrayType="zeusns:Catalog.Rule.SyntaxCheck[1]" xsi:type="soapenc:Array"><Item xsi:type="zeusns:Catalog.Rule.SyntaxCheck"><valid xsi:type="xsd:boolean">true</valid><warnings xsi:type="xsd:string" /><errors xsi:type="xsd:string" /></Item></results></namesp1:checkSyntaxResponse></soap:Body></soap:Envelope>
    # => {:results=>
    #   {:item=>
    #     {:valid=>true,
    #      :warnings=>{:"@xsi:type"=>"xsd:string"},
    #      :errors=>{:"@xsi:type"=>"xsd:string"},
    #      :"@xsi:type"=>"zeusns:Catalog.Rule.SyntaxCheck"},
    #    :"@soapenc:array_type"=>"zeusns:Catalog.Rule.SyntaxCheck[1]",
    #    :"@xsi:type"=>"soapenc:Array"}}
  end
end
