require 'stingray/control_api'

module Stingray::ControlApi::SoapHelperMethods
  def _make_soap_request(ns, method, soap_body)
    self.client.request(ns, method) do
      soap.namespaces['xmlns:soapenc'] = 'http://schemas.xmlsoap.org/soap/encoding/'
      soap.body = soap_body
    end
  end

  def _make_names_values_soap_request(names_values_hash, ns, operation)
    raise ArgumentError.new('No names -> values given!') if names_values_hash.empty?
    body = _build_many_keyed_string_arrays(names_values_hash, :names, :values)
    _make_soap_request(ns, operation, body)
  end

  def _make_names_soap_request(names_array, ns, operation)
    raise ArgumentError.new('No names given!') if names_array.empty?
    body = _build_string_array(names_array, :names)
    _make_soap_request(ns, operation, body)
  end

  def _build_string_array(strings, key_name)
    body = {
      key_name => {},
      :attributes! => {
        key_name => {'soapenc:arrayType' => "xsd:string[#{strings.length}]"}
      }
    }

    strings.each_with_index do |s,i|
      body[key_name][:"s#{i}"] = s
    end

    body
  end

  def _build_many_keyed_string_arrays(key_array_hash, keys_name, arrays_name)
    body = {
      keys_name => {},
      arrays_name => {
        :attributes! => {},
      },
      :attributes! => {
        keys_name => {'soapenc:arrayType' => "xsd:string[#{key_array_hash.length}]"},
        arrays_name => {'soapenc:arrayType' => "xsd:list[#{key_array_hash.length}]"},
      },
    }

    i = 0
    key_array_hash.each do |k,arr|
      body[keys_name][:"k#{i}"] = k

      k_arr = {:attributes! => {}}
      arr.each_with_index do |node,j|
        k_arr[:"node#{j}"] = node
      end

      body[arrays_name][:attributes!][:"k#{i}"] = {
        'soapenc:arrayType' => "xsd:string[#{arr.length}]"
      }

      body[arrays_name][:"k#{i}"] = k_arr
      i += 1
    end

    body
  end
end
