require 'csv'

class CsvCreator
  def create(array)
    array = array.map(&:as_json)
    array_keys = array.first.keys

    CSV.generate(headers: true) do |csv|
      csv << array_keys

      array.each_with_index do |obj, index|
        csv << [index + 1, obj.values].flatten.compact
      end
    end
  end
end
