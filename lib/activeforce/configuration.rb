module Configuration

  def configuration
    yield self
  end

  def define_configurables(*names, default: nil)
    names.each do |name|
      class_variable_set("@@#{name}", default)

      define_class_method "#{name}=" do |value|
        class_variable_set("@@#{name}", value)
      end

      define_class_method name do
        class_variable_get("@@#{name}")
      end
    end
  end

  private

  def define_class_method(name, &block)
    (class << self; self; end).instance_eval do
      define_method name, &block
    end
  end

end
