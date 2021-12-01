class CurrencyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless Money::Currency.find(value.to_sym)
      record.errors.add attribute, (options[:message] || "Incorrect currency")
    end
  end
end