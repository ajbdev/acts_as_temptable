require 'temptable/read_only_model'

module Temptable

  module ActsAsTemptable
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_temptable(options = {})
        cattr_accessor :temp_table_sql
        cattr_accessor :temp_table_params
        cattr_accessor :column_cache
        include Temptable::ReadOnlyModel

        self.temp_table_sql = options[:sql]

        @columns = {}
      end

      def temp_table(params = {})
        self.temp_table_params = params
        self.ensure_temp_table_created
      end

      def ensure_temp_table_created
        unless self.is_temp_table_created?
          self.create_temp_table
        end
      end

      def temp_table_name
        self.set_temp_table_name
        self.table_name
      end

      def set_temp_table_name
        self.table_name = "tmp_#{self.model_name.underscore.downcase}_#{temp_table_params.values.join('_')}"
      end

      def is_temp_table_created?
        connection.execute("SELECT COUNT(*) FROM pg_catalog.pg_class WHERE relkind = 'r' AND relname = '#{self.temp_table_name}'")
            .to_a[0]["count"]
            .to_i > 0
      end

      def destroy_temp_table
        connection.execute("DROP TABLE IF EXISTS #{self.temp_table_name}")
      end

      def recreate_temp_table
        destroy_temp_table
        create_temp_table
      end

      def create_temp_table
        sql = self.temp_table_sql.respond_to?(:call) ? self.temp_table_sql.call(self.temp_table_params) : self.temp_table_sql

        connection.execute("CREATE TEMP TABLE #{self.temp_table_name} AS " + sql)
      end

      def columns
        @columns[self.temp_table_name] ||= connection.execute( <<SQL
                  SELECT a.attrelid, a.attname, format_type(a.atttypid, a.atttypmod),
                         pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                         c.collname, col_description(a.attrelid, a.attnum) AS comment
                    FROM pg_attribute a
                    LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                    LEFT JOIN pg_class cl ON cl.oid = a.attrelid
                    LEFT JOIN pg_type t ON a.atttypid = t.oid
                    LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                   WHERE cl.relkind='r' AND cl.relname = '#{self.temp_table_name}'
                     AND a.attnum > 0 AND NOT a.attisdropped
                   ORDER BY a.attnum
SQL
        ).to_a.map do |column|
          ActiveRecord::ConnectionAdapters::PostgreSQLColumn.new(column["attname"], nil, column["format_type"], column["attnotnull"] == 'f')
        end
      end
    end
  end
end

