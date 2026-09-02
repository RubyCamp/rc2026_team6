module AvailabilitiesHelper
  def time_label(datetime)
    datetime.hour
    case(datetime.hour)
    when(6..10)
      "朝"
    when(10..16)
      "昼"
    when(16..22)
      "夜"
    else
      "休み"
    end


end
end
