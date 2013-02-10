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

  # Set the SSL verification mode for all SOAP communication.  Valid values are
  # really up to the HTTP backend, but some known good ones are ":none" and
  # ":peer".  Setting the STINGRAY_SSL_VERIFY_NONE environmental variable will
  # result in this method defaulting to ":none".  Once a configuration model
  # has been initialized, its verify mode cannot be modified through this
  # function.  Instead, set the model's deeply-nested attribute of
  # `.client.http.auth.ssl.verify_mode`.
  def ssl_verify_mode(mode = nil)
    unless mode.nil?
      @ssl_verify_mode = mode
    end
    @ssl_verify_mode || ENV['STINGRAY_SSL_VERIFY_NONE'] ? :none : :peer
  end

  # A little helper that allows for iteration over SOAP results that may be
  # singular or plural (or just plain missing.)  A block must always be given.
  def foreach(anything, &block)
    raise SyntaxError.new('Block needed!') unless block_given?
    [*(anything || [])].each(&block)
  end
end
