module Tl3
  class Tl3Controller < ::ApplicationController
    requires_plugin Tl3

    before_action :ensure_logged_in

    def index
    end
  end
end
