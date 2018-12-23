Pod::Spec.new do |s|
  s.name = 'SwiftCodableGeoJSON'
  s.version = '0.0.1'
  s.summary = 'A Swift implementation of GeoJSON'
  s.description = <<-DESC
  This implementation of GeoJSON conforms to [rfc7946](https://tools.ietf.org/html/rfc7946) and is designed for usage with `Codable` objects.
                   DESC

  s.homepage = 'https://github.com/guykogus/SwiftCodableGeoJSON'
  s.license = { type: 'MIT', file: 'LICENSE' }
  s.authors = { 'Guy Kogus' => 'guy.kogus@gmail.com' }
  s.documentation_url = 'http://geojson.org'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.swift_version = '4.2'
  s.source = { git: 'https://github.com/guykogus/SwiftCodableGeoJSON', tag: s.version.to_s }
  s.source_files = 'SwiftCodableGeoJSON/*.swift'
  s.dependency = 'SwiftCodableJSON'
end
