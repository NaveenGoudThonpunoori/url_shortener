class AddSanityUrlToShortUrl < ActiveRecord::Migration[5.2]
  def change
    add_column :short_urls, :sanity_url, :string
  end
end
