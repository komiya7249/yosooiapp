module HomeHelper
  def self.weather_code_return(code)
    if code >=0 && code <= 2
      return "sun"
    elsif code === 3
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

  def self.wear_symbol_return(num)
    if num >= 30
      return "tshirt"
    elsif num >= 25 && num <= 29
      return "short_sleeve_shirt"
    elsif num >= 20 && num <= 24
      return "long_sleeve_shirt"
    elsif num >= 16 && num <= 19
      return "Jacket"
    elsif num >= 12 && num <= 15
      return "nit"
    elsif num >= 8 && num <= 11
      return "light_outerwear"
    elsif num >= 6 && num <= 7
      return "outer"
    elsif num <= 5
      return "down_coat"
    end
  end
end
