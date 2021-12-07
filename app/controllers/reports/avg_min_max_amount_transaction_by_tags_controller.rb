module Reports
  class AvgMinMaxAmountTransactionByTagsController < BaseReportController
    creator AvgMinMaxAmountTransactionByTagsReportCreator

    private

    def reports_params
      {
        start_date: params[:start_date],
        final_date: params[:final_date],
        tags: params[:tags],
        csv: params[:csv]
      }
    end
  end
end
