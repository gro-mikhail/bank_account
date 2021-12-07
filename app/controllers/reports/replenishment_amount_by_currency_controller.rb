module Reports
  class ReplenishmentAmountByCurrencyController < BaseReportController
    creator ReplenishmentAmountByCurrencyReportCreator

    private

    def reports_params
      {
        start_date: params[:start_date],
        final_date: params[:final_date],
        clients: params[:clients],
        csv: params[:csv]
      }
    end
  end
end
