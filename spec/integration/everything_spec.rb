require 'stingray/exec/dsl'

describe 'Everything', :integration => true do
  include Stingray::Exec::DSL

  context 'when managing users' do
    it 'should be able to list users' do
      stingray_exec do
        ssl_verify_mode :none
        users.list_users[:values][:item].should_not be_nil
      end
    end

    it 'should be able to list groups' do
      stingray_exec do
        ssl_verify_mode :none
        users.list_groups[:values][:item].should_not be_nil
      end
    end
  end
end
