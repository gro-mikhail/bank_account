class AvgMinMaxAmountTransactionByTagsReportCreator
  attr_reader :start_date, :final_date, :tags

  def initialize(params)
    @start_date = time(params[:start_date])
    @final_date = time(params[:final_date])
    @tags = params[:tags]&.map(&:upcase)
  end

  def create
    report = Transaction.where(transfer: true, transaction_type: 'DOWN', created_at: (@start_date..@final_date))
                        .group(:currency)
                        .select('currency, min(amount) as "min_amount", max(amount) as "max_amount", avg(amount) as "average_amount"')
    report = report.joins(client: :tags)
                   .where(tags: { name: @tags })
                   .group('tags.name')
                   .select('tags.name as "tag_name"') if @tags.present?
    report
  end

  private

  def time(date)
    Time.parse(date) if date
  end
end
