class Affiliate < ApplicationRecord
  
  include HasReference
  
  belongs_to :user, optional: true
  
  def self.generate_tag
    generate_reference(length: 5, attribute: :tag)
  end
  
  def verification_needed?
    verification_needed.size.positive?
  end
  
  def verification_form_names
    verification_needed.map { |name| convert_form_name(name) }
  end
  
  def convert_form_name(attribute)
    "account[#{attribute.gsub('.', '][')}]"
  end
end