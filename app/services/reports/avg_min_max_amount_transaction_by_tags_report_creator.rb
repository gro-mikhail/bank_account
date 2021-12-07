module Reports
  class AvgMinMaxAmountTransactionByTagsReportCreator
    attr_reader :file_name
    def initialize(params)
      @start_date = time(params[:start_date])
      @final_date = time(params[:final_date])
      @tags = params[:tags]&.map(&:upcase)
      @file_name = "avg_min_max_amount_transaction_by_tags#{Time.now}.csv"
    end

    def call
      report = Transaction.where(transfer: true, transaction_type: 'DOWN', created_at: (start_date..final_date))
                          .group(:currency)
                          .select('currency, min(amount) as "min_amount", max(amount) as "max_amount", avg(amount) as "average_amount"')
      report = report.joins(client: :tags)
                     .where(tags: { name: tags })
                     .group('tags.name')
                     .select('tags.name as "tag_name"') if @tags.present?
      report
    end

    private

    attr_reader :start_date, :final_date, :tags

    def time(date)
      Time.parse(date) if date
    end
  end
end
