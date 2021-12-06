require 'csv'

class CsvCreator
  def initialize() end

  def create(array)
    array = array.map(&:as_json)
    array_keys = array.map(&:keys).flatten.uniq

    CSV.generate(headers: true) do |csv|
      csv << array_keys

      array.each_with_index do |obj, index|
        csv << [index + 1, array_keys.map { |attr| obj[attr] }].flatten.compact
      end
    end
  end
end
