module TaskHelpers
  def select_date_and_time(datetime, options = {})
    field = options[:from]
    select datetime.year.to_s, from: "#{field}_1i"
    select datetime.strftime('%B'), from: "#{field}_2i"
    select datetime.day.to_s, from: "#{field}_3i"
    select format('%02d', datetime.hour), from: "#{field}_4i"
    select format('%02d', datetime.min), from: "#{field}_5i"
  end
end

RSpec.configure do |config|
  config.include TaskHelpers, type: :feature
end
