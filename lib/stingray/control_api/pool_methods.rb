require 'stingray/control_api'

module Stingray::ControlApi::PoolMethods
  # Adds pools with nodes.  The `pool_configs` argument should be a hash of
  # pool name => node list mappings
  def add_pool(pool_configs)
    body = {
      :names => {},
      :nodes => {
        :attributes! => {},
      },
      :attributes! => {
        :names => {'soapenc:arrayType' => "xsd:string[#{pool_configs.length}]"},
        :nodes => {'soapenc:arrayType' => "xsd:list[#{pool_configs.length}]"},
      },
    }

    i = 0
    pool_configs.each do |name,nodes|
      body[:names][:"name#{i}"] = name

      name_nodes = {:attributes! => {}}
      nodes.each_with_index do |node,j|
        name_nodes[:"node#{j}"] = node
      end

      body[:nodes][:attributes!][:"name#{i}"] = {
        'soapenc:arrayType' => "xsd:string[#{nodes.length}]"
      }

      body[:nodes][:"name#{i}"] = name_nodes
      i += 1
    end

    self.client.request('Pool', :add_pool) do
      soap.namespaces['xmlns:soapenc'] = 'http://schemas.xmlsoap.org/soap/encoding/'
      soap.body = body
    end
  end

  # Deletes pools with names given in `names`, each of which should be a string.
  def delete_pool(*names)
    raise ArgumentError.new('No names given!') if names.empty?

    body = {
      :names => {},
      :attributes! => {
        :names => {'soapenc:arrayType' => "xsd:string[#{names.length}]"}
      }
    }

    names.each_with_index do |name,i|
      body[:names][:"name#{i}"] = name
    end

    self.client.request('Pool', :delete_pool) do
      soap.namespaces['xmlns:soapenc'] = 'http://schemas.xmlsoap.org/soap/encoding/'
      soap.body = body
    end
  end
end
