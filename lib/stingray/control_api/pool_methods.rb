require 'stingray/control_api'
require 'stingray/control_api/soap_helper_methods'

module Stingray::ControlApi::PoolMethods
  include Stingray::ControlApi::SoapHelperMethods

  %w(
    add_pool
    get_nodes_priority_value
    get_nodes_weightings
  ).map(&:to_sym).each do |op|
    define_method(:"_custom_#{op}") do |node_configs|
      body = _build_many_keyed_string_arrays(node_configs, :names, :nodes)
      _make_soap_request('Pool', op, body)
    end
  end

  %w(
    delete_pool
    get_autoscale_cloudcredentials
    get_autoscale_cluster
    get_autoscale_datacenter
    get_autoscale_datastore
    get_autoscale_enabled
    get_autoscale_external
    get_autoscale_hysteresis
    get_autoscale_imageid
    get_autoscale_ipstouse
    get_autoscale_lastnode_idletime
    get_autoscale_max_nodes
    get_autoscale_min_nodes
    get_autoscale_names
    get_autoscale_port
    get_autoscale_refractory
    get_autoscale_response_time
    get_autoscale_scaledown_level
    get_autoscale_scaleup_level
    get_autoscale_sizeid
    get_bandwidth_class
    get_disabled_nodes
    get_draining_nodes
    get_ftp_support_rfc2428
    get_failpool
    get_keepalive
    get_keepalive_non_idempotent
    get_load_balancing_algorithm
    get_max_connect_time
    get_max_connections_pernode
    get_max_idle_connections_per_node
    get_max_keepalives_per_node
    get_max_queue_size
    get_max_reply_time
    get_monitors
    get_node_conn_close
    get_node_connection_attempts
    get_node_fail_time
    get_node_use_nagle
    get_nodes
    get_nodes_connection_counts
    get_nodes_last_used
    get_note
    get_passive_monitoring
    get_persistence
    get_priority_enabled
    get_priority_nodes
    get_priority_values
    get_queue_timeout
    get_smtp_send_start_tls
    get_ssl_client_auth
    get_ssl_encrypt
    get_ssl_enhance
    get_ssl_send_close_alerts
    get_ssl_server_name_extension
    get_ssl_strict_verify
    get_transparent
    get_udp_accept_from
    get_udp_accept_from_ip_mask
    get_weightings
  ).map(&:to_sym).each do |op|
    define_method(:"_custom_#{op}") do |*names|
      _make_names_soap_request(names, 'Pool', op)
    end
  end

  %w(
    add_draining_nodes
    add_monitors
    add_nodes
    disable_nodes
    enable_nodes
    remove_draining_nodes
    remove_monitors
    remove_nodes
    set_autoscale_cloudcredentials
    set_autoscale_cluster
    set_autoscale_datacenter
    set_autoscale_datastore
    set_autoscale_enabled
    set_autoscale_external
    set_autoscale_hysteresis
    set_autoscale_imageid
    set_autoscale_ipstouse
    set_autoscale_lastnode_idletime
    set_autoscale_max_nodes
    set_autoscale_min_nodes
    set_autoscale_name
    set_autoscale_port
    set_autoscale_refractory
    set_autoscale_response_time
    set_autoscale_scaledown_level
    set_autoscale_scaleup_level
    set_autoscale_sizeid
    set_bandwidth_class
    set_disabled_nodes
    set_draining_nodes
    set_ftp_support_rfc2428
    set_failpool
    set_keepalive
    set_keepalive_non_idempotent
    set_load_balancing_algorithm
    set_max_connect_time
    set_max_connections_pernode
    set_max_idle_connections_pernode
    set_max_keepalives_pernode
    set_max_queue_size
    set_max_reply_time
    set_monitors
    set_node_conn_close
    set_node_connection_attempts
    set_node_fail_time
    set_node_use_nagle
    set_nodes
    set_nodes_priority_value
    set_nodes_weightings
    set_note
    set_passive_monitoring
    set_persistence
    set_priority_enabled
    set_priority_nodes
    set_queue_timeout
    set_smtp_send_start_tls
    set_ssl_client_auth
    set_ssl_encrypt
    set_ssl_enhance
    set_ssl_send_close_alerts
    set_ssl_server_name_extension
    set_ssl_strict_verify
    set_transparent
    set_udp_accept_from
    set_udp_accept_from_ip_mask
  ).map(&:to_sym).each do |op|
    define_method(:"_custom_#{op}") do |names_values|
      _make_names_values_soap_request(names_values, 'Pool', op)
    end
  end
end
