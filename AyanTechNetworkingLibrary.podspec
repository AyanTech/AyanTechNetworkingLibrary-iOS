Pod::Spec.new do |spec|
  spec.name = "AyanTechNetworkingLibrary"
  spec.version = "1.2.2"
  spec.summary = "Networking library for comunicate AyanTech web services"
  spec.homepage = "https://github.com/AyanTech/AyanTechNetworkingLibrary-iOS"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Sepehr Behroozi" => 'sep.behroozi@gmail.com' }
  spec.social_media_url = "https://twitter.com/3pehrbehroozi"
  spec.swift_version = "4.2"
  spec.platform = :ios, "9.1"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/AyanTech/AyanTechNetworkingLibrary-iOS.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "AyanTechNetworkingLibrary/**/*.{h,swift}"
end
