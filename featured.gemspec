Gem::Specification.new do |s|
  s.name = "featured"
  s.email = "mark.fine@gmail.com"
  s.version = "0.1"
  s.description = "Features."
  s.summary = "features"
  s.authors = ["Mark Fine"]
  s.homepage = "http://github.com/heroku/featured"

  s.files = Dir["lib/**/*.rb"] + Dir["Gemfile*"]
  s.require_paths = ["lib"]
  s.add_dependency "fog", "~> 1.8"
end
