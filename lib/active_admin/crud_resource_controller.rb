module ActiveAdmin
  # All Resources Controller inherits from this controller.
  # It implements actions and helpers for resources.
  class CrudResourceController < ResourceController
    before_filter :skip_sidebar!

    protected

    # Use #desc and #asc for sorting.
    def sort_order(chain)
      chain # just return the chain
    end

    # Disable filters
    def search(chain)
      chain
    end
  end
end
