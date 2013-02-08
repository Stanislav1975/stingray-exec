require 'stingray/exec'

class Stingray::Exec::Cli
  USAGE = <<-EOU.gsub(/^  /, '')
  Usage: stingray-exec <script>
  EOU

  def self.main(argv = ARGV)
    if argv.first
      script = argv.first
      if File.exists?(argv.first)
        script = File.read(argv.first)
      end

      Stingray::Exec.configure

      require_relative 'dsl'

      Class.new(Object) do
        extend Stingray::Exec::DSL
        stingray_exec do
          eval(script)
        end
      end

      return 0
    end

    $stderr.puts USAGE
    return 1
  end
end

if $0 == __FILE__
  exit Stingray::Exec::Cli.main
end
