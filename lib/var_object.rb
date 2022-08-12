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
		headers.each do |method_name|
			self.class.send(:define_method, "#{method_name}") do
				row["#{method_name}"]
			end			
		end
	end
end