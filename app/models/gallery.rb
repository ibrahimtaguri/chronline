class Gallery < ActiveRecord::Base
  include FriendlyId
  SLUG_PATTERN = %r[(\d{4}/\d{2}/\d{2}/)?[a-zA-Z_\d\.\-]+]
  friendly_id :name, use: [:slugged, :chronSlug]

  self.per_page = 25

  set_primary_key :id

  attr_accessible :name, :gid, :description, :section, :images, :date, :primary_image_id

  belongs_to :primary_image, class_name: "Gallery::Image"
  has_many :images, class_name: "Gallery::Image", dependent: :destroy
  validates :name, presence: true
  validates :gid, presence: true, uniqueness: true

  scope :nonempty, -> { joins(:images).uniq }
  # replaces all sequences on non-alphanumeric characters with a dash
  # used to get the proper url for the photoshelter buy page
  def photoshelter_slug
    name.strip.gsub(/[^[:alnum:]]+/, "-")
  end

  def credit
    if images.size > 0
      images.first.credit
    end
  end

  def empty?
    images.empty?
  end

  # largely copied from post.rb
  def normalize_friendly_id(name, max_chars=100)
    s = super 
    (date || Date.today).strftime('%Y/%m/%d/') + s
  end

  def self.scrape
    @api = PhotoshelterAPI.new
    @api.get_all_galleries.each do |gallery|
      if !Gallery.exists?(:gid => gallery['id']) then
        begin
          date = Date.strptime gallery['name'], '%Y/%m/%d'
        rescue ArgumentError
          date = nil
        end
        gallery_name = gallery['name'].gsub(/[0-9]+\/[0-9]+\/[0-9]+/, '').sub(/^[\s\-]+/, '')
        gal = Gallery.create(gid: gallery['id'], name: gallery_name, description: gallery['description'], date: date)
        images = @api.get_gallery_images gallery['id']
        if images then
          images.each do |image|
            info = @api.get_image_info image['id']
            if !Gallery::Image.exists?(:pid => image['id'], :gid => gallery['id']) then
              Gallery::Image.create(:pid => image['id'], :gid => gallery['id'], :caption => info['caption'], :credit => info['credit'], :title => info['title'], gallery_id: gal.id) if gal
            end
          end
        end
        gal.update_attributes(primary_image_id: gal.images.first.pid) if !gal.empty?
      end
    end
  end

end
