# frozen_string_literal: true

# Add to spec_helper.rb to require Physical factories:
#
#   require "physical/test_support"
#   FactoryBot.definition_file_paths.concat(Physical::TestSupport.factory_paths)
#   FactoryBot.reload

module Physical
  module TestSupport
    def self.factory_paths
      spec = Gem::Specification.find_by_name("physical")
      root = Pathname.new(spec.gem_dir)
      Dir[
        root.join("lib", "physical", "spec_support", "factories", "*_factory.rb")
      ].map { |path| path.sub(/.rb\z/, "") }
    end
  end
end
