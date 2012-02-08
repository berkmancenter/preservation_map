class GeoGraph < ActiveRecord::Base
    belongs_to :user
    has_many :places
    has_attached_file :import_data
    validates_attachment_content_type :import_data, :content_type => 'text/csv'
    validates_attachment_size :import_data, :in => 1..1.megabyte
    validates :name, :presence => true, :length => { :in => 3..50 }
    attr_accessor :import_data_content_type
end
