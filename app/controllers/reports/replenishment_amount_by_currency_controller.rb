module Reports
  class ReplenishmentAmountByCurrencyController < ApplicationController
    def create
      report = ReplenishmentAmountByCurrencyReportCreator.new(reports_params).create

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
        start_date: params[:start_date],
        final_date: params[:final_date],
        clients: params[:clients],
        csv: params[:csv]
      }
    end

    def file_name
      "replenishment_amount_by_currency-#{Time.now}.csv"
    end
  end
end
