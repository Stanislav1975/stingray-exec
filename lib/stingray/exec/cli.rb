require 'optparse'
require 'stingray/exec'

class Stingray::Exec::Cli
  BANNER = <<-EOB.gsub(/^  /, '')
  Usage: stingray-exec [options] <script>

  Executes scripts in the context of Stingray Traffic Manager configuration
  models, allowing for access to all methods documented in the Control API.  The
  <script> argument may be a string expression or a filename (or "-" for stdin),
  and if ommitted will cause stingray-exec to drop into a fancy DSL-tastic pry
  console.

  All of the command-line configuration flags may also be given as
  environmental variables, as noted in the help text for each flag.  The
  "endpoint" flag/var deserves special attention as the expected value is buried
  in the Stingray docs.
  e.g.: STINGRAY_ENDPOINT='https://stingray-pool-master.example.com:9090/soap'

  See the 'examples' directory in the stingray-exec gem tree for some
  (surprise!) examples of how to do stuff.

  ------- FAIR WARNING: -------
  The vast majority of Control API methods have been wrapped in very dumb
  generated code.  Read-only methods work fine, but methods that take arguments
  invariably require custom implementations -- the kind of thing that's typically
  generated from a WSDL, which we can't legally redistribute.  The Control API
  makes things even more fun by requiring the use of soapenc arrays and lists of
  arrays.  If you want or need to implement such code, the "soap_helper_methods.rb"
  file in the stingray-exec source may be of help. YMMV.


  EOB

  def self.main(argv = ARGV)
    new(argv).run!
  end

  attr_reader :argv, :script, :filename

  def initialize(argv)
    @argv = argv
  end

  def run!
    parse_options
    prepare_script
    configure
    evaluate_script
  end

  private
  def parse_options
    OptionParser.new do |opts|
      opts.banner = BANNER
      opts.on('-v', '--verbose', 'Yelling. (DEBUG=1)') do |v|
        ENV['DEBUG'] = '1'
      end
      opts.on('-k', '--insecure', 'Allow "insecure" SSL connections ' <<
          '(STINGRAY_SSL_VERIFY_NONE=1)') do |k|
        ENV['STINGRAY_SSL_VERIFY_NONE'] = '1'
      end
      opts.on('-u', '--user-password',
          'Stingray username:password (STINGRAY_AUTH=<user>:<pass>)') do |u|
        ENV['STINGRAY_AUTH'] = u
      end
      opts.on('-C', '--credentials', 'Credentials file containing ' <<
          'username:password (STINGRAY_AUTH=<user>:<pass>)') do |c|
        ENV['STINGRAY_AUTH'] = File.read(c).strip
      end
      opts.on('-E', '--endpoint',
          'Stingray server SOAP endpoint (STINGRAY_ENDPOINT=<uri>)') do |endpoint|
        ENV['STINGRAY_ENDPOINT'] = endpoint
      end
      opts.on('-V', '--stingray-version', 'Stingray server version, ' <<
          'e.g. "9.0" or "9.1" (STINGRAY_VERSION="9.1")') do |ver|
        ENV['STINGRAY_VERSION'] = ver
      end
    end.parse!(argv)
  end

  def prepare_script
    @script = argv.first || ''
    @filename = ''
    if File.exists?(@script)
      @filename = @script
      @script = File.read(@script)
    elsif @script == '-'
      @script = $stdin.read
    end
  end

  def configure
    Stingray::Exec.configure
  end

  def evaluate_script
    require_relative 'dsl'

    # reassign so that scoping is happy once we're inside the new class block
    script_string = script
    script_filename = filename
    shebang_offset = script_string =~ /^#!/ ? 1 : 0

    unless script_string.empty?
      Class.new(Object) do
        extend Stingray::Exec::DSL
        begin
          stingray_exec(script_string, script_filename, shebang_offset)
        rescue => e
          $stderr.puts e.message
          $stderr.puts e.backtrace.join("\n") if ENV['DEBUG']
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
