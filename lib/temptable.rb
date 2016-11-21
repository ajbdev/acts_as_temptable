require "temptable/version"
require "temptable/acts_as_temptable"
require "temptable/read_only_model"

module Temptable
  if defined?(Rails::Railtie)
    class Railtie < Rails::Railtie
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, Temptable::ActsAsTemptable)
      end
    end
  else
    ActiveRecord::Base.send(:include, Temptable::ActsAsTemptable) if defined?(ActiveRecord)
  end
end
