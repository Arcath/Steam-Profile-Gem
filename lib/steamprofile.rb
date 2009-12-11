require 'rubygems'
require 'nokogiri'
require 'open-uri'

class SteamProfile
	def initialize(config)
		#Set caching to false unless specified
		config[:cache] ||= false
		#Make sure the profile url has been supplied and is valid
		unless config[:profile_url]
			config[:error] = "No Profile URL Specified"
		else
			unless config[:profile_url] =~ /^http:\/\/steamcommunity\.com\/[id|profiles]/ then
				config[:error] = "Mal-Formed Profile URL"
			else
				config[:xml_url] = config[:profile_url] + "?xml=1"
			end
		end
		#Instanize the config array
		@config=config
		#Load Up Nokogiri
		unless config[:error] 
			@nokogiri=Nokogiri::XML::Reader(open(config[:xml_url]))
		end
		self.nokogiri
	end
	
	def field
		return @fields
	end
	
	def nokogiri
		@fields={}
		@fields[:game]=[]
		@fields[:game_hours_played]=[]
		gi=0
		ghpi=0
		@nokogiri.each do |node|
			if node.name == "steamID" then
				@fields[:name] ||= self.stripcdata(node.inner_xml)
			elsif node.name == "gameName" then
				if gi != 3 && node.inner_xml != "" then
					@fields[:game][gi] ||= self.stripcdata(node.inner_xml)
					gi+=1
				end
			elsif node.name == "hoursPlayed" then
				if ghpi != 3 && node.inner_xml != "" then
					@fields[:game_hours_played][ghpi] ||= node.inner_xml
					ghpi+=1
				end
			elsif node.name == "onlineState" then
				@fields[:online_state] ||= node.inner_xml
			elsif node.name == "stateMessage" then
				@fields[:state_message] ||= self.stripcdata(node.inner_xml)
			elsif node.name == "avatarIcon" then
				@fields[:avatar] ||= self.stripcdata(node.inner_xml)
				@fields[:avatar_med] ||= @fields[:avatar].gsub(/\.jpg/,"_medium.jpg")
				@fields[:avatar_full] ||= @fields[:avatar].gsub(/\.jpg/,"_full.jpg")
			end
		end		
	end
	def stripcdata(s)
		s.scan(/<!\[CDATA\[(.*?)\]\]>/).join
	end
end

#s=SteamProfile.new(:profile_url => "http://steamcommunity.com/profiles/76561197990531359")
