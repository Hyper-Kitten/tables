module HyperKittenMeow
  class Engine < ::Rails::Engine
    isolate_namespace HyperKittenTables
  end
end
