class Project < ApplicationRecord
  has_secure_token
  has_many :sources, :dependent => :delete_all
end
