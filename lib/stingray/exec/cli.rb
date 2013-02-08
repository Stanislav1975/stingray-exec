require 'optparse'
require 'stingray/exec'

class Stingray::Exec::Cli
  BANNER = <<-EOB.gsub(/^  /, '')
  Usage: stingray-exec [options] <script>

  Executes scripts in the context of Stingray Traffic Manager configuration
  models, allowing for access to all methods documented in the Control API.
  The <script> argument may be a string expression or a filename, and if ommitted
  will cause stingray-exec to drop into a console.

  See the 'examples' directory in the stingray-exec gem tree for some (surprise!)
  examples of how to do some stuff.

  EOB

  def self.main(argv = ARGV)
    OptionParser.new do |opts|
      opts.banner = BANNER
      opts.on('-v', '--verbose', 'Yelling.') do |v|
        ENV['DEBUG'] = '1'
      end
    end.parse!

    script = argv.first || ''
    if File.exists?(script)
      script = File.read(script)
    end

    Stingray::Exec.configure

    require_relative 'dsl'

    unless script.empty?
      Class.new(Object) do
        extend Stingray::Exec::DSL
        stingray_exec do
          eval(script)
        end
      end
    else
      require 'pry'
      Pry.config.prompt_name = 'stingray-exec'
      TOPLEVEL_BINDING.eval('self').extend Stingray::Exec::DSL
      Pry.start
    end

    return 0
  end
end

if $0 == __FILE__
  exit Stingray::Exec::Cli.main
end
