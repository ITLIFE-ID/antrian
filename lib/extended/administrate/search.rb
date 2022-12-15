# frozen_string_literal: true

# Overriding administrate default search behavior
# https://github.com/thoughtbot/administrate/blob/9071a7eff60cbbcaf0ddc1b7bfb6bfe7d22b0028/lib/administrate/search.rb#L5

module Extended
  module Administrate
    class Search < ::Administrate::Search
      private

      def query_template
        search_attributes.map do |attr|
          table_name = query_table_name(attr)
          searchable_fields(attr).map do |field|
            column_name = column_to_query(field)
            if attribute_concat_fields(field)
              "LOWER(CAST((#{attribute_concat_fields_to_query(table_name,
                field)}) AS CHAR(256))) LIKE ?"
            else
              "LOWER(CAST(#{table_name}.#{column_name} AS CHAR(256))) LIKE ?"
            end
          end.join(" OR ")
        end.join(" OR ")
      end

      def attribute_concat_fields(field)
        if attribute_types[field].try(:options)
          return attribute_types[field].try(:options)[:concat_searchable_fields]
        end

        nil
      end

      def attribute_concat_fields_to_query(table_name, field)
        attribute_concat_fields(field).map do |column|
          "#{table_name}.#{column_to_query(column)}"
        end.join(" || ' ' || ")
      end
    end
  end
end
