require 'middleman-core'

module Middleman
  class Smusher < ::Middleman::Extension
    option :service, 'SmushIt', 'Smushing service (SmushIt, PunyPng)'
    option :path, nil, 'Path to images to smush, defaults to :images_dir if not set'
    option :with_gifs, false, 'Also smush GIFs'

    def initialize(app, options_hash={}, &block)
      super
      require 'smusher'
    end

    def after_build(builder)
      smush_dir = options.path || File.join(app.config[:build_dir], app.config[:images_dir])
      prefix = app.config[:build_dir] + File::SEPARATOR

      files = ::Smusher.send :images_in_folder, smush_dir, options.with_gifs

      files.each do |file|
        ::Smusher.optimize_image(file, service: options.service, quiet: true, convert_gifs: options.with_gifs)
        builder.thor.say_status :smushed, file.sub(prefix, "")
      end
    end
  end
end
