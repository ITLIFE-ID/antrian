module ActiveRecord
  module SessionStore
    class CustomSession < Session
      def save
        super
      end
    end
  end
end
