class VarObject
	def initialize(row, headers)
		# byebug
		# self.class.send(:define_method, :speak) do
		# 		"MOOOO added"
		# end
		# class << self
		# 	headers.each do |attribute|
		# 		define_method :"find_by_#{attribute}" do |value|
		# 			all.find {|prod| prod.public_send(attribute) == value }
		# 		end
		# 	end
		# end
		# headers.each do |method_name|
		# 	self.class.send(:define_method, "#{method_name}") do
		# 		row["#{method_name}"]
		# 	end			
		# end
		@row = row
		@headers = headers
	end


	def set_data(file, name)
		matched_objects = []
		current_file_name = File.basename(file.filename.to_s, File.extname(file.filename.to_s)).downcase
		url = ActiveStorage::Blob.service.send(:path_for, file.key)
		if current_file_name!= name
			CSV.foreach(url, headers: true) do |row|
				#TODO need to configurable this USUBJID
				if self.USUBJID.present? && row["USUBJID"].present? && row["USUBJID"] == self.USUBJID
					temp = VarObject.new(row, row.headers)
					temp.set_methods
					matched_objects << temp
				end
			end
		end
		return current_file_name, matched_objects
	end

	def set_methods
		@headers.each do |method_name|
			self.class.send(:define_method, "#{method_name}") do
				@row["#{method_name}"]
			end			
		end		
	end
end