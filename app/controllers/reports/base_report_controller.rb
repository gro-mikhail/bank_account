module Reports
  class BaseReportController < ApplicationController
    include Reports::Creatable

    def create
      creator = self.class.report_creator.new(reports_params)
      report = creator.call
      if reports_params[:csv]
        csv_report = CsvCreator.new.create(report)
        send_data csv_report, filename: creator.file_name, status: 200
      else
        render json: report, status: 200
      end
    end

    private

    def reports_params
      raise NotImplementedError
    end
  end
end