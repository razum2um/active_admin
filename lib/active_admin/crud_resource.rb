module ActiveAdmin
  class CrudResource < Resource

    # make sure we always decorate resource
    def decorator_class
      if decorator_class_name
        ActiveSupport::Dependencies.constantize(decorator_class_name)
      else
        namespace, _, short_resource_name = resource_class_name.rpartition '::'
        namespace = ActiveSupport::Dependencies.constantize namespace
        cls_name = "#{short_resource_name}Decorator"
        if namespace.const_defined? cls_name
          namespace.const_get cls_name
        else
          namespace.const_set cls_name, Class.new(ActiveAdmin::CrudDecorator)
        end
      end
    end

    def resource_table_name
      decorator_class.quoted_table_name
    end

    def resource_quoted_column_name(column)
      column
    end

    def comments?
      false
    end
  end
end
