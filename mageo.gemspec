# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mageo"
  s.version = ""

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["ippei94da"]
  s.date = "2012-04-04"
  s.description = "MAth GEOmetry library to deal with 2 and 3 dimension space.\n    Cartesian and internal coordinate systems can be used.\n    This includes besic objects in 3 dimensional space.\n  "
  s.email = "ippei94da@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "lib/mageo.rb",
    "lib/mageo/axes.rb",
    "lib/mageo/cylinder.rb",
    "lib/mageo/octahedron.rb",
    "lib/mageo/polar2d.rb",
    "lib/mageo/polar3d.rb",
    "lib/mageo/polyhedron.rb",
    "lib/mageo/segment.rb",
    "lib/mageo/sphere.rb",
    "lib/mageo/tetrahedron.rb",
    "lib/mageo/triangle.rb",
    "lib/mageo/vector.rb",
    "lib/mageo/vector3d.rb",
    "lib/mageo/vector3dinternal.rb",
    "test/helper.rb",
    "test/test_axes.rb",
    "test/test_cylinder.rb",
    "test/test_octahedron.rb",
    "test/test_polar2d.rb",
    "test/test_polar3d.rb",
    "test/test_polyhedron.rb",
    "test/test_segment.rb",
    "test/test_sphere.rb",
    "test/test_tetrahedron.rb",
    "test/test_triangle.rb",
    "test/test_vector.rb",
    "test/test_vector3d.rb",
    "test/test_vector3dinternal.rb"
  ]
  s.homepage = "http://github.com/ippei94da/mageo"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.21"
  s.summary = "MAth GEOmetry library to deal with 2 and 3 dimension space."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.1.3"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<builtinextension>, [">= 0"])
      s.add_development_dependency(%q<malge>, [">= 0.0.1"])
    else
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.1.3"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<builtinextension>, [">= 0"])
      s.add_dependency(%q<malge>, [">= 0.0.1"])
    end
  else
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.1.3"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<builtinextension>, [">= 0"])
    s.add_dependency(%q<malge>, [">= 0.0.1"])
  end
end
