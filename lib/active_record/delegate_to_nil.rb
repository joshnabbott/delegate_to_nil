module ActiveRecord
  class Base
    class << self
      def delegate_to_nil(*methods)
        options = methods.pop
        unless options.is_a?(Hash) && to = options[:to]
          raise ArgumentError, "Delegation needs a target. Supply an options hash with a :to key as the last argument (e.g. delegate :hello, :to => :greeter)."
        end

        if options[:prefix] == true && options[:to].to_s =~ /^[^a-z_]/
          raise ArgumentError, "Can only automatically set the delegation prefix when delegating to a method."
        end

        prefix = options[:prefix] && "#{options[:prefix] == true ? to : options[:prefix]}_"

        methods.each do |method|
          define_method method do
            send(:delegator_for, to).send(method)
          end
          define_method "#{method}=" do |value|
            send(:delegator_for, to).send("#{method}=", value)
          end
        end
      end
    end

  protected
    def delegator_for(association)
      send("#{association}=", self.class.reflect_on_association(association).klass.new) if send(association).nil?
      send(association)
    end
  end
end