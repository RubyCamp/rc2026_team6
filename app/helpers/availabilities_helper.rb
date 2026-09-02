module AvailabilitiesHelper

    def time_label(datetime, datetime1)
    datetime.hour
    datetime1.hour
   if datetime.hour <10 && datetime1.hour >16
    "朝-昼-夜"
   elsif datetime.hour <10 && datetime1.hour <16
    "朝-昼"
   elsif datetime.hour >10 && datetime1.hour >16
    "昼-夜"
   elsif datetime.hour >6 && datetime1.hour <10
    "朝"
   elsif datetime.hour >10 && datetime1.hour <16
    "昼"
   elsif datetime.hour >16 && datetime1.hour <22
    "夜"

    end
  end


end
