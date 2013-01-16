require 'delegate'

# Minimal example of a decorator
module ActiveAdmin
  # class we inherit from
  # abstract class to build resource proxies from
  # like:
  #
  #   eval "class PostDecorator < CrudDecorator(Post); end"
  class CrudDecorator < SimpleDelegator

    def initialize(resource_class)
      __setobj__ resource_class
    end

    def resource_class
      __getobj__
    end

    def quoted_table_name
      resource_class.quoted_table_name if resource_class.respond_to? :quoted_table_name
    end

    class << self
      def decorate(collection_or_object)
        if collection_or_object.respond_to?(:to_ary)
          namespace, _, short_decorator_name = self.name.rpartition '::'
          namespace = ActiveSupport::Dependencies.constantize namespace
          cls_name = "#{short_decorator_name.gsub /Decorator\Z/, 'CollectionDecorator'}"
          cls = if namespace.const_defined? cls_name
            namespace.const_get cls_name
          else
            namespace.const_set cls_name, Class.new(ActiveAdmin::CrudCollectionDecorator)
          end
          cls.new(collection_or_object, self)
        else
          new(collection_or_object)
        end
      end

      def model_name
        ActiveModel::Name.new resource_class
      end

      def fields
        resource_class.fields
      end

      def resource_class
        namespace, _, short_decorator_name = self.name.rpartition '::'
        resource_class = ActiveSupport::Dependencies.constantize "#{namespace}::#{short_decorator_name.gsub /Decorator\Z/, '' }"
      end
    end
  end
end
