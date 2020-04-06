class AddPgTrgmExtensionToDb < ActiveRecord::Migration[6.0]
  def change
    enable_extension "plpgsql"
    enable_extension "pg_trgm"
    enable_extension "fuzzystrmatch"
  end
end
