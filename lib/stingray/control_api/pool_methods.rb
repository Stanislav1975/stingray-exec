require 'stingray/control_api'
require 'stingray/control_api/soap_helper_methods'

module Stingray::ControlApi::PoolMethods
  include Stingray::ControlApi::SoapHelperMethods

  def _custom_add_pool(pool_configs)
    body = _build_many_keyed_string_arrays(pool_configs, :names, :nodes)
    _make_soap_request('Pool', :add_pool, body)
  end

  def _custom_delete_pool(*names)
    _make_names_soap_request(names, 'Pool', :delete_pool)
  end

  def _custom_get_nodes(*names)
    _make_names_soap_request(names, 'Pool', :get_nodes)
  end

  def _custom_set_monitors(monitor_configs)
    _make_names_values_soap_request(monitor_configs, 'Pool', :set_monitors)
  end

  %w(add add_draining remove remove_draining enable disable).each do |node_op|
    define_method(:"_custom_#{node_op}_nodes") do |node_configs|
      _make_names_values_soap_request(node_configs, 'Pool', :"#{node_op}_nodes")
    end
  end
end
