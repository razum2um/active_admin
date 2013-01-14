require 'delegate'

module ActiveAdmin
  # abstract class to build resource collection proxies from
  class CrudCollectionDecorator < DelegateClass(ActiveRecord::Relation)
    include Enumerable

    delegate :as_json, :collect, :map, :each, :[], :all?, :include?, :first, :last, :shift, :to => :decorated_collection

    def initialize(collection, decorator_class)
      super(collection)
      @klass = decorator_class
    end

    %w[reorder].each do |meth|
      send(:define_method, meth) do |*args|
        decorated_collection
      end
    end

    protected

    def wrapped_collection
      __getobj__
    end

    def klass
      @klass || raise(NotImplementedError, "cannot use CollectionDecorator directly")
    end

    def decorated_collection
      @decorated_collection ||= wrapped_collection.collect { |member| klass.decorate(member) }
    end
    alias_method :to_ary, :decorated_collection

    def each(&blk)
      to_ary.each(&blk)
    end
  end
end
