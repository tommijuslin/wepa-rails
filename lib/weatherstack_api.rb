class WeatherstackApi
  def self.weather_in(city)
    city = city.downcase
    city_weather = "#{city}_weather"
    Rails.cache.fetch(city_weather, expires_in: 1.hours) { get_weather_in(city) }
  end

  def self.get_weather_in(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query=#{city}"
    response = HTTParty.get(url)
    OpenStruct.new response.parsed_response["current"]
  end

  def self.key
    return nil if Rails.env.test?
    raise 'WEATHERSTACK_APIKEY env variable not defined' if ENV['WEATHERSTACK_APIKEY'].nil?

    ENV.fetch('WEATHERSTACK_APIKEY')
  end
end
