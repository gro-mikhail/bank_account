module Reports
  class SumAccountsByCurrencyReportCreator
    attr_reader :file_name

    def initialize(params)
      @tags = params[:tags]&.map(&:upcase)
      @file_name = "sum_accounts_by_currency-#{Time.now}.csv"
    end

    def call
      report = Account.group(:currency).select('currency, sum(balance) as "sum"')
      report = report.joins(client: :tags)
                     .where(tags: { name: @tags })
                     .group('tags.name')
                     .select('tags.name as "tag_name"') if @tags.present?
      report
    end

    private

    attr_reader :tags
  end
end
