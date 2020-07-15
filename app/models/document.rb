# frozen_string_literal: true

class Document < ApplicationRecord
  has_logidze

  validates :name, :body, presence: true
end
