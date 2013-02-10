require 'stingray/control_api'
require 'stingray/control_api/soap_helper_methods'

module Stingray::ControlApi::CatalogRuleMethods
  include Stingray::ControlApi::SoapHelperMethods

  %w(
    delete_rule
    get_rule_details
  ).map(&:to_sym).each do |op|
    define_method(:"_custom_#{op}") do |*names|
      _make_names_soap_request(names, 'Catalog.Rule', op)
    end
  end

  def _custom_add_rule(rule_configs)
    body = _build_many_keyed_string_arrays(rule_configs, :names, :texts)
    _make_soap_request('Catalog.Rule', :add_rule, body)
  end

  def _custom_check_syntax(*rule_texts)
    raise ArgumentError.new('No rules given!') if rule_texts.empty?
    body = _build_string_array(rule_texts, :rule_text)
    _make_soap_request('Catalog.Rule', :check_syntax, body)
  end

  def _custom_set_rule_text(rule_configs)
    body = _build_many_keyed_string_arrays(rule_configs, :names, :text)
    _make_soap_request('Catalog.Rule', :set_rule_text, body)
  end
end
