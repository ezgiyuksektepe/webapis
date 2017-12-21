require 'json'
require 'open-uri'
require_relative 'APIProxy'

class Mp3IdentifierApi < APIProxy
  def initialize()
    super("https://api.acoustid.org/v2/lookup?client=C4DBA7Jb34" +
      "&meta=recordings+releasegroups+compress&duration=%{duration}" +
      "&fingerprint=%{fingerprint}")
  end

  def identify(duration, fingerprint)
    logger = Log.instance
    logger.level = Log::INFO
    
    params = {
      duration: duration,
      fingerprint: fingerprint
    }
    begin
      response = callApi(params)
      #puts response

      max = 0
      if response["status"] != "ok"
        raise "Couldn't Match The Song"
      end
    
      for result in response["results"]
        if result["score"] > max
          max = result["score"]
          id = result["id"]
          name = result["recordings"][0]["artists"][0]["name"].to_s
          title = result["recordings"][0]["title"]
        end
      end
      final_result = {
        :title => title,
        :artist => name
      }
    rescue Exception => e
      logger.error("Error fetching data from the music identifier API. " +
        "Returning a fallback response")
      logger.error(e.message)

      final_result = {
        :title => "Pink Floyd",
        :artist => "breathe"
      }
    end

    final_result
  end
end
