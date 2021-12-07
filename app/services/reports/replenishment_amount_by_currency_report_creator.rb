module Reports
  class ReplenishmentAmountByCurrencyReportCreator
    attr_reader :file_name
    def initialize(params)
      @start_date = time(params[:start_date])
      @final_date = time(params[:final_date])
      @clients = params[:clients]&.map(&:upcase)
      @file_name = "replenishment_amount_by_currency-#{Time.now}.csv"
    end

    def call
      report = Transaction.where(transfer: false, created_at: (start_date..final_date))
                          .group(:currency)
                          .select('currency, sum(amount) as "sum"')
      report = report.joins(:client)
                     .where(clients: { identification_number: clients })
                     .group('clients.identification_number')
                     .select('clients.identification_number as "identification_number"') if clients.present?
      report
    end

    private

    attr_reader :start_date, :final_date, :clients

    def time(date)
      Time.parse(date) if date
    end
  end
end
