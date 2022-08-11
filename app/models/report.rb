class Report < ActiveRecord::Base

    has_many_attached :data_files
    has_many_attached :result_files
    #validate :correct_document_mime_type
    belongs_to :template
    validates :data_files, presence: true, blob: { content_type: ['text/csv', 'application/json'], size_range: 1..(5.megabytes) }


    private
  
    def correct_document_mime_type
      if data_files.attached?
        data_files.each do |file|
            errors.add(:document, 'Must be a CSV') if !file.content_type.in?(%w(text/csv application/json))
        end
      end
    end
end