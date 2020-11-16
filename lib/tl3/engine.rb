module Tl3
  class Engine < ::Rails::Engine
    engine_name "Tl3".freeze
    isolate_namespace Tl3

    config.after_initialize do
      Discourse::Application.routes.append do
        mount ::Tl3::Engine, at: "/tl3"
      end
    end
  end
end
