require_relative "lib/etter/version"

Gem::Specification.new do |spec|
  spec.name          = "etter"
  spec.version       = Etter::VERSION
  spec.authors       = ["Carl Frederick"]
  spec.email         = ["galvertez@gmail.com"]
  spec.licenses      = ["MIT"]
  spec.summary       = "Setters and Getters and Properties"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/galvertez/etter"
  spec.files         = Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]
end
