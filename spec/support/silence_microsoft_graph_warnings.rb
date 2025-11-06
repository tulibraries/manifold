# frozen_string_literal: true

module Warning
  class << self
    unless method_defined?(:warn_without_microsoft_graph_filter)
      alias_method :warn_without_microsoft_graph_filter, :warn

      def warn(message = nil, *args, **kwargs, &block)
        if message&.include?("microsoft_graph") && message&.include?("redefining 'object_id'")
          return
        end

        warn_without_microsoft_graph_filter(message, *args, **kwargs, &block)
      end
    end
  end
end

