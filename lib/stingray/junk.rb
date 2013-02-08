module Stingray
  class Junk
    def self.snakify(str)
      str.gsub(/::/, '/').
        gsub(/\./, '_').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

    def self.constify(str)
      str.gsub(/\./, '').gsub(/_/, '')
    end
  end
end
