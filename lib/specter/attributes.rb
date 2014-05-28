require 'specter/field'

module Specter
  module Attributes

    def self.included(mod)
      mod.extend(ClassMethods)
    end

    module ClassMethods

      def attribute(name, &block)
        attributes[name.to_sym] = block

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}
            attributes[:#{name}]
          end
        RUBY
      end

      def attributes
        @attributes ||= {}
      end
    end # ClassMethods

    def attributes
      @attributes ||= Hash[self.class.attributes.collect { |name, block|
        [name, Field.new(&block)]
      }]
    end
  end # Attributes
end # Specter
