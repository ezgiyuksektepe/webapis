require 'json'
require 'open-uri'
require_relative 'APIProxy'
require_relative 'Log'

#en yakin konser
class EventFinderApi < APIProxy
  def initialize()
    super("https://rest.bandsintown.com/artists/%{artist}/events?" +
    "app_id=eyJUb2tlblR5cGUiOiJBUEkiLCJzYWx0IjoiNDBjNTQ4OGItYWUzMS00ZWI2LW" +
    "E1NzYtYTdiZTEzYmMyMzkxIiwiYWxnIjoiSFM1MTIifQ.eyJqdGkiOiIyNDFkZjMwZC04" +
    "MzdlLTQxZGQtYmQ0ZS04ODcwNzg2ZmI3NzEiLCJpYXQiOjE1MTA3OTA3NDZ9.9Zg39yKe" +
    "hRTdE33o4gzjYGAgezWMKPbCK65I-bLrY5GUDIPTpK5gTjaPVFLItKAozcYSVBbz8gzo2" +
    "otruciYEw")
  end

  def getEvents(artist)
    params = {
      artist: artist
    }

    logger = Log.instance
    logger.level = Log::INFO

    begin
      parsed_response = callApi(params)

      if parsed_response.length == 0
        #puts "Couldn't find an upcoming event for #{artist}."
        results = {}
      else
        dates = parsed_response[0]["datetime"].to_s.split("T")
        date = dates[0]
        time = dates[1]
        venue = parsed_response[0]["venue"]["name"]
        city = parsed_response[0]["venue"]["city"]
        country = parsed_response[0]["venue"]["country"]

        results = {
          :date => date,
          :time => time,
          :venue => venue,
          :city => city,
          :country => country
        }
      end
    rescue Exception => e
      logger.error("Error fetching data from the event API. " +
        "Returning a fallback response")
      logger.error(e.message)

      results = {
        :date => "2018-10-01",
        :time => "02:00",
        :venue => "Turk Telekom Arena",
        :city => "Istanbul",
        :country => "Turkey"
      }
    end

    results
  end
end
