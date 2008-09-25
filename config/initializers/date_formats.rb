Date::DATE_FORMATS[:formal] = lambda do |date|
  date.strftime "%A, %B #{date.day.ordinalize}, %Y"
end
