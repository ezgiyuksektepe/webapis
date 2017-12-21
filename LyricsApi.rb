require 'json'
require 'open-uri'
require_relative 'APIProxy'
require_relative 'LyricsContainer'

#sozlerin yuzde 30u
class LyricsApi < APIProxy
  attr_accessor :lyrics, :parsedResponse

  def initialize()
    super("https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?format=json" +
      "&q_track=%{song}&q_artist=%{artist}" +
      "&apikey=a6505ac9a7c7f20d8254b8c054288013")
  end

  def getLyrics(artist, song)
    logger = Log.instance
    logger.level = Log::INFO

    params = {
      song: song,
      artist: artist
    }

    begin
      parsedResponse = callApi(params)
      if parsedResponse["message"]["header"]["status_code"] != 200
        raise "Couldn't Match The Song"
      end
      lyrics = parsedResponse["message"]["body"]["lyrics"]["lyrics_body"]
    rescue Exception => e
      logger.error("Error fetching data from the lyrics API. "+
        "Using a fallback response")
      logger.error(e.message)

      lyrics = "Couldn't fetch the lyrics.\nThis is the fallback song\n\n" +
        "Breathe, breathe in the air\n" +
        "Don't be afraid to care\n" +
        "Leave but don't leave me\n" +
        "Look around, choose your own ground\n" +
        "For long you live and high you fly\n" +
        "And smiles you'll give and tears you'll cry\n" +
        "And all your touch and all you see\n" +
        "Is all your life will ever be"
    end

    LyricsContainer.new(lyrics)
  end
end
