module ActiveAdmin
  class CrudResourceController < ResourceController

    protected

    # Disable sorting
    def sort_order(chain)
      chain
    end

    # Disable filters
    def search(chain)
      chain
    end
  end
end
