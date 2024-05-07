module HomeHelper
  def self.weather_code_return(code)
    if code === 0
      return "sun"
    elsif code >= 1 && code <= 3
      return "cloud"
    elsif code >= 45 && code <= 57
      return "fog"
    elsif code >= 61 && code <= 82
      return "rain"
    elsif code >= 85 && code <= 86
      return "snow"
    elsif code >= 95 && code <= 99
      return "thunder"
    end
  end
end
