require 'stingray/exec/dsl'

describe 'Users', :integration => true do
  include Stingray::Exec::DSL

  it 'should be able to list users' do
    stingray_exec do
      foreach(users.list_users[:values][:item]) do |item|
        item.should_not be_nil
      end
    end
  end

  it 'should be able to list groups' do
    stingray_exec do
      foreach(users.list_groups[:values][:item]) do |item|
        item.should_not be_nil
      end
    end
  end
end
