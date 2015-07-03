# encoding: utf-8

guard :rspec, cmd: "bundle exec rspec" do

  watch(%r{^spec/.+_spec\.rb$})

  watch(%r{^lib/abstract_mapper/(.+)\.rb$}) do |m|
    "spec/unit/abstract_mapper/#{m[1]}_spec.rb"
  end

  watch("lib/abstract_mapper.rb") { "spec" }
  watch("spec/spec_helper.rb")    { "spec" }

end # guard :rspec
