require 'stingray/exec/dsl'

describe 'Pool', :integration => true do
  include Stingray::Exec::DSL

  def test_pool_name
    @test_pool_name ||= "test_pool_#{rand(9999)}_#{Time.now.to_i}"
  end

  it 'should be able to add and delete pools' do
    stingray_exec do
      pool.add_pool(test_pool_name => ['localhost:9999'])
      pool.delete_pool(test_pool_name)
    end
  end

  it 'should be able to get the current nodes for pools' do
    stingray_exec do
      pool.add_pool(test_pool_name => ['localhost:9999'])
      pool.get_nodes(test_pool_name)[:nodes][:item][:item].should == 'localhost:9999'
      pool.delete_pool(test_pool_name)
    end
  end

  it 'should be able to add and remove nodes from pools' do
    stingray_exec do
      pool.add_pool(test_pool_name => ['localhost:9999'])
      pool.add_nodes(test_pool_name => ['localhost:8888', 'localhost:7777'])
      pool.remove_nodes(test_pool_name => ['localhost:8888'])
      pool.remove_nodes(test_pool_name => ['localhost:7777'])
      pool.delete_pool(test_pool_name)
    end
  end

  it 'should be able to add and remove draining nodes from pools' do
    stingray_exec do
      pool.add_pool(test_pool_name => ['localhost:9999'])
      pool.add_nodes(test_pool_name => ['localhost:8888', 'localhost:7777'])
      pool.add_draining_nodes(test_pool_name => ['localhost:8888'])
      pool.remove_draining_nodes(test_pool_name => ['localhost:8888'])
      pool.delete_pool(test_pool_name)
    end
  end

  it 'should be able to add and remove monitors from pools' do
    stingray_exec do
      pool.add_pool(test_pool_name => ['localhost:9999'])
      pool.add_monitors(test_pool_name => ['Simple HTTP', 'Ping'])
      pool.remove_monitors(test_pool_name => ['Ping'])
      pool.delete_pool(test_pool_name)
    end
  end

  it 'should be able to set monitors for pools' do
    stingray_exec do
      pool.add_pool(test_pool_name => ['localhost:9999'])
      pool.set_monitors(test_pool_name => ['Ping', 'Simple HTTP'])
      pool.delete_pool(test_pool_name)
    end
  end
end
