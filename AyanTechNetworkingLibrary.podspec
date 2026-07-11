Pod::Spec.new do |spec|
  spec.name = "AyanTechNetworkingLibrary"
  spec.version = "1.7.0"
  spec.summary = "Networking library for communicate AyanTech web services"
  spec.homepage = "https://github.com/AyanTech/AyanTechNetworkingLibrary-iOS"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Sepehr Behroozi" => 'sep.behroozi@gmail.com' }
  spec.social_media_url = "https://twitter.com/3pehrbehroozi"
  spec.swift_version = "5.0"
  spec.platform = :ios, "11.0"
  spec.requires_arc = true
  spec.source = { :git => "https://github.com/AyanTech/AyanTechNetworkingLibrary-iOS.git", branch: "v#{spec.version}", submodules: true }
  spec.source_files = "AyanTechNetworkingLibrary/**/*.{h,swift}"
end
