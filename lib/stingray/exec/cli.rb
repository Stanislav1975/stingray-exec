require 'stingray/exec'

class Stingray::Exec::Cli
  def self.main
    0
  end
end

if $0 == __FILE__
  exit Stingray::Exec::Cli.main
end
