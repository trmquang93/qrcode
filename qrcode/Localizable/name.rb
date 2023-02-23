require 'xcodeproj'
require 'fileutils'

project_path = '../../qrcode.xcodeproj'
project = Xcodeproj::Project.open(project_path)

for o in project.objects do 
    if o.is_a? Xcodeproj::Project::Object::PBXProject
        if o.isa == "PBXProject"
            group = o
            break
        end
    end
end

for o in project.objects do 
  if o.is_a? Xcodeproj::Project::Object::PBXGroup
      if o.path == "Localizable"
          LocalizableGroup = o
          break
      end
  end
end

# variantGroup = group.new(Xcodeproj::Project::Object::PBXVariantGroup)

variant = LocalizableGroup.new_variant_group("Localizable.strings")

langs = [                           # Languages to convert. i.e. English:en
  "en",
  "vi",
  "ar",
  "fr",
  "de",
  "id",
  "it",
  "ja",
  "ko",
  "pt-PT",
  "zh-Hans",
  "es",
  "th",
  "zh-Hant",
  "tr",
  "ca",
  "pl",
  "sk",
  "ms",
  "hr",
  "cs",
  "da",
  "nl"
  ]

  group.known_regions = langs

for language in langs do
  foldername = language + ".lproj"
  filename = foldername + "/Localizable.strings"
  FileUtils.mkdir_p foldername
  FileUtils.cp("Localizable.strings", filename)
end

for language in langs do
  foldername = language + ".lproj"
  filename = foldername + "/Localizable.strings"
  file = project.new_file(filename)
  file.move(variant)
  file.name = language
end

project.save
