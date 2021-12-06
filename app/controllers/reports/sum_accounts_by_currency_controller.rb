module Reports
  class SumAccountsByCurrencyController < ApplicationController
    def create
      report = SumAccountsByCurrencyReportCreator.new(reports_params).create

      if reports_params[:csv]
        csv_report = CsvCreator.new.create(report)
        send_data csv_report, filename: file_name, status: 200
      else
        render json: report, status: 200
      end
    end

    private

    def reports_params
      {
        tags: params[:tags],
        csv: params[:csv]
      }
    end

    def file_name
      "sum_accounts_by_currency-#{Time.now}.csv"
    end
  end
end
