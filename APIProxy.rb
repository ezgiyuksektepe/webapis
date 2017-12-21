require_relative 'Log'

class APIProxy
  def initialize(base_url_format)
    @base_url_format = base_url_format
  end

  def callApi(parameters)
    logger = Log.instance
    logger.level = Log::INFO

    # Fix space characters
    parameters.merge!(parameters) do |key, val|
      URI.encode(val.to_s)
    end

    logger.info("Will call #{@base_url_format} with #{parameters}")
    url = @base_url_format % parameters
    logger.info("Requesting #{url}")

    uri = URI.parse(url)

    response = uri.read
    logger.info("Response #{response}")

    parsed_response = JSON.parse(response)
    parsed_response
  end
end
