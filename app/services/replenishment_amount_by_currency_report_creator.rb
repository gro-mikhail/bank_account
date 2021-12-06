class ReplenishmentAmountByCurrencyReportCreator
  attr_reader :start_date, :final_date, :clients

  def initialize(params)
    @start_date = time(params[:start_date])
    @final_date = time(params[:final_date])
    @clients = params[:clients]&.map(&:upcase)
  end

  def create
    report = Transaction.where(transfer: false, created_at: (@start_date..@final_date))
                        .group(:currency)
                        .select('currency, sum(amount) as "sum"')
    report = report.joins(:client)
                   .where(clients: { identification_number: @clients })
                   .group('clients.identification_number')
                   .select('clients.identification_number as "identification_number"') if @clients.present?
    report
  end

  private

  def time(date)
    Time.parse(date) if date
  end
end
