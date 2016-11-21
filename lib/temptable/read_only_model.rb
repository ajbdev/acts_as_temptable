module Temptable
  module ReadOnlyModel
    def readonly?
      true
    end

    def self.delete_all
      raise ActiveRecord::ReadOnlyRecord
    end

    def delete
      raise ActiveRecord::ReadOnlyRecord
    end

    def self.destroy_all
      raise ActiveRecord::ReadOnlyRecord
    end

    def destroy
      raise ActiveRecord::ReadOnlyRecord
    end

  end
end
