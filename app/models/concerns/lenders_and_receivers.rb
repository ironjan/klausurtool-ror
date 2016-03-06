module LendersAndReceivers
  extend ActiveSupport::Concern

  class_methods do

    def lenders_and_receivers
      get_unique_field_values(:lender) | get_unique_field_values(:receiver)
    end

    private

    def get_unique_field_values(symbol)
      select(symbol)
          .where("updated_at > ?", 31.days.ago)
          .map(&symbol)
          .uniq
    end
  end


end
