module Reports
  class SumAccountsByCurrencyController < BaseReportController
    creator SumAccountsByCurrencyReportCreator

    private

    def reports_params
      {
        tags: params[:tags],
        csv: params[:csv]
      }
    end
  end
end
