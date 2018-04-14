module Reportable
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    
    attr_accessor :report_builder
    
    def columns(options = {}, &block)
      self.report_builder = ReportBuilder.new(options, &block)
    end
    
    def to_csv(collection: nil)
      report_builder.build(collection || find_collection,
        output: "", format: :csv)
    end
    
    def to_json(collection: nil)
      result = report_builder.build(collection || find_collection)
      result.to_json
    end
    
    def to_csv_enumerator(collection: nil)
      Enumerator.new do |y|
        report_builder.build(collection || find_collection,
          output: y, format: :csv)
      end
    end
  end
end