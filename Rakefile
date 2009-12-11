require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('steamprofile','0.0.1') do |p|
	p.description	= "Loads a given steam profile in ruby"
	p.url		= "http://www.arcath.net"
	p.author	= "Adam \"Arcath\" Laycock"
	p.email		= "adam@arcath.net"
	p.ignore_pattern= ["tmp/*", "script/*"]
	p.development_dependencies = []
	p.runtime_dependencies = ["nokogiri >=1.4.0"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
