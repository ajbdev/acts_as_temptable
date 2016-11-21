require 'temptable/read_only_model'

module Temptable

  module ActsAsTemptable
    extend ActiveSupport::Concern

    module ClassMethods

      def acts_as_temptable(options = {})
        cattr_accessor :temp_table_sql
        cattr_accessor :temp_table_params
        include Temptable::ReadOnlyModel

        self.temp_table_sql = options[:sql]
      end

      def temp_table(params = {})
        self.temp_table_params = params
        self.destroy_temp_table
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
        connection.execute("SELECT COUNT(*) FROM pg_catalog.pg_class WHERE relkind = 'r' AND relname = #{connection.quote(self.temp_table_name)}")
            .to_a[0]["count"]
            .to_i > 0
      end

      def destroy_temp_table
        connection.execute("DROP TABLE IF EXISTS #{self.temp_table_name}")
      end

      def create_temp_table
        sql = self.temp_table_sql.respond_to?(:call) ? self.temp_table_sql.call(self.temp_table_params) : self.temp_table_sql

        connection.execute("CREATE TEMP TABLE #{self.temp_table_name} AS " + sql)
      end
    end
  end
end

