class SumAccountsByCurrencyReportCreator
  attr_reader :tags

  def initialize(params)
    @tags = params[:tags]&.map(&:upcase)
  end

  def create
    report = Account.group(:currency).select('currency, sum(balance) as "sum"')
    report = report.joins(client: :tags)
                   .where(tags: { name: @tags })
                   .group('tags.name')
                   .select('tags.name as "tag_name"') if @tags.present?
    report
  end
end
