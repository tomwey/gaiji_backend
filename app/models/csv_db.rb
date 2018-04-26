require 'csv'
class CsvDb
  class << self
    def convert_save(model_name, csv_data)
      csv_file = csv_data.read
      CSV.parse(csv_file, :headers => true) do |row|
        target_model = model_name.classify.constantize
        puts target_model
        new_object = target_model.new
        column_iterator = -1
        target_model.column_names.each do |key|
          column_iterator += 1
          unless key == "ID"
            value = row[column_iterator]
            puts value
            new_object.send "#{key}=", value.force_encoding("utf-8")
          end
        end
        new_object.save
      end # end parse
    end # end convert save
  end
end