module Reports
  module Creatable
    extend ActiveSupport::Concern

    module ClassMethods
      attr_reader :report_creator

      def creator(service_name)
        @report_creator = service_name
      end
    end
  end
end
