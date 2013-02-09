require 'stingray/exec'
require 'stingray/control_api'

module Stingray::Exec::DSL
  def stingray_exec(string = '', filename = '', lineno = 0, &block)
    unless string.empty?
      instance_eval(string, filename, lineno)
    else
      instance_eval(&block)
    end
  end

  Stingray::ControlApi::CONFIGURATIONS.each do |cfg_ns,variations|
    define_method(variations[:snaked]) do
      ivar = :"@#{variations[:snaked].to_s}"

      if inst = instance_variable_get(ivar)
        return inst
      end

      inst = Stingray::ControlApi::const_get(variations[:consted]).new
      inst.client.http.auth.ssl.verify_mode = ssl_verify_mode
      instance_variable_set(ivar, inst)
      inst
    end
  end

  def ssl_verify_mode(mode = nil)
    unless mode.nil?
      @ssl_verify_mode = mode
    end
    @ssl_verify_mode || ENV['STINGRAY_SSL_VERIFY_NONE'] ? :none : :peer
  end

  def foreach(anything, &block)
    raise SyntaxError.new('Block needed!') unless block_given?
    [*(anything || [])].each(&block)
  end
end
