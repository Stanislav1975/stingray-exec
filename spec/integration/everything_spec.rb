require 'stingray/exec/dsl'

describe 'stingray-exec', :integration => true do
  include Stingray::Exec::DSL

  def test_pool_name
    @test_pool_name ||= "test_pool_#{rand(9999)}_#{Time.now.to_i}"
  end

  context 'when managing users' do
    it 'should be able to list users' do
      stingray_exec do
        ssl_verify_mode :none
        foreach(users.list_users[:values][:item]) do |item|
          item.should_not be_nil
        end
      end
    end

    it 'should be able to list groups' do
      stingray_exec do
        ssl_verify_mode :none
        foreach(users.list_groups[:values][:item]) do |item|
          item.should_not be_nil
        end
      end
    end
  end

  context 'when managing pools' do
    xit 'should be able to add a pool' do
      stingray_exec do
        ssl_verify_mode :none
        pool.add_pool(
          'names' => [test_pool_name],
          'nodes' => [['localhost:9999']]
        )
      end
    end
  end
end
