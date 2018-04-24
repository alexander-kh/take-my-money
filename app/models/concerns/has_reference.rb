module HasReference
  
  extend ActiveSupport::Concern
  
  module ClassMethods
    
    def generate_reference(length: 10, attribute: :reference)
      loop do
        result = SecureRandom.hex(length)
        return result unless exists?(attribute => result)
      end
    end
    
  end
end