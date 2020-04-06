# == Schema Information
#
# Table name: Comapny
#
#  id              :integer          not null, primary key
#  name            :string             not null

class Company < ApplicationRecord
    include PgSearch::Model

    pg_search_scope :search_name, against: :name, using: [:dmetaphone, :trigram]

    validates :name, uniqueness: true
end
