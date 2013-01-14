require 'delegate'

# Minimal example of a decorator
module ActiveAdmin
  # class we inherit from
  # abstract class to build resource proxies from
  # like:
  #
  #   eval "class PostDecorator < CrudDecorator(Post); end"
  class CrudDecorator < SimpleDelegator

    #def initialize(resource_class)
    #  @resource_class = resource_class
    #end
    def resource_class
      __getobj__
    end

    def class
      resource_class
    end

    def quoted_table_name
      binding.pry
      resource_class.quoted_table_name
    end

    class << self
      def decorate(collection_or_object)
        if collection_or_object.respond_to?(:to_ary)
          namespace, _, short_decorator_name = self.name.rpartition '::'
          cls = ActiveSupport::Dependencies.constantize(namespace).const_set "#{short_decorator_name.gsub 'Decorator', 'CollectionDecorator'}", Class.new(ActiveAdmin::CrudCollectionDecorator)
          cls.new(self, collection_or_object)
        else
          new(collection_or_object)
        end
      end

      def model_name
        ActiveModel::Name.new resource_class
      end
    end
  end
end
