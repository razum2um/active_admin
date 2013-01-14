module ActiveAdmin
  class CrudResource < Resource

    # make sure we always decorate resource
    def decorator_class
      if decorator_class_name
        ActiveSupport::Dependencies.constantize(decorator_class_name)
      else
        namespace, _, short_resource_name = resource_class_name.rpartition '::'
        ActiveSupport::Dependencies.constantize(namespace).const_set "#{short_resource_name}Decorator", Class.new(ActiveAdmin::CrudDecorator)
      end
    end

    def resource_table_name
      decorator_class.quoted_table_name
    end

    def resource_quoted_column_name(column)
      column
    end
  end
end
