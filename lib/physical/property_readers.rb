# frozen_string_literal: true

module Physical
  module PropertyReaders
    private

    NORMALIZED_METHOD_REGEX = /(\w+)\??$/.freeze

    def method_missing(method)
      symbolized_properties = properties.symbolize_keys
      method_name = normalize_method_name(method)
      if symbolized_properties.key?(method_name)
        symbolized_properties[method_name]
      else
        super
      end
    end

    def respond_to_missing?(method, *args)
      method_name = normalize_method_name(method)
      properties.symbolize_keys.key?(method_name) || super
    end

    def normalize_method_name(method)
      method.to_s.sub(NORMALIZED_METHOD_REGEX, '\1').to_sym
    end
  end
end
