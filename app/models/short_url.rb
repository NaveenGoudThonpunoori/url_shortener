class ShortUrl < ApplicationRecord
  def self.to_csv
    attributes = %w{original_url short_url}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      ShortUrl.all.each do |url|
        csv << [url.original, url.short]
      end
    end
  end
end
