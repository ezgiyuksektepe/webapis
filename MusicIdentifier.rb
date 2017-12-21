require 'json'
require 'open-uri'
require_relative 'EventFinderApi'
require_relative 'LyricsApi'
require_relative 'Mp3IdentifierApi'

class MusicIdentifier
  def self.identify(file)
    fingerprint_json = `./fpcalc -json #{file}`
    fingerprint_json = JSON.parse(fingerprint_json)

    identify_api = Mp3IdentifierApi.new
    result = identify_api.identify(fingerprint_json["duration"].to_i,
      fingerprint_json["fingerprint"])

    puts "*** Artist: #{result[:artist]} Title: #{result[:title]} ***"
    puts "\n"

    lyrics = LyricsApi.new.getLyrics(result[:artist], result[:title])
    puts "*** Here are the lyrics ***"
    while lyrics.hasNext()
      puts lyrics.next()
    end
    puts "\n"

    puts "*** Next upcoming event ***"
    event = EventFinderApi.new.getEvents(result[:artist])
    if event == {}
      puts "Couldn't find an upcoming event for #{result[:artist]}"
    else
      puts "The next event for #{result[:artist]} is:"
      puts " on #{event[:date]} at #{event[:time]}"
      puts " It will be at #{event[:venue]} "
      puts "   in #{event[:city]}, #{event[:country]}"
    end
  end
end
