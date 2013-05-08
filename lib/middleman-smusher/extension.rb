module Middleman
  module Smusher
    class << self
      def registered(app, options={})
        require "smusher"

        # options[:service] ||= "SmushIt"
        options[:quiet] = true

        smush_dir, prefix = nil, nil
        app.after_configuration do
          smush_dir = if options.has_key?(:path)
            options.delete(:path)
          else
            File.join(build_dir, images_dir)
          end

          prefix = build_dir + File::SEPARATOR
        end

        app.after_build do |builder|
          files = ::Smusher.class_eval do
            images_in_folder(smush_dir)
          end

          files.each do |file|
            ::Smusher.optimize_image(
              [file],
              options
            )

            builder.say_status :smushed, file.sub(prefix, "")
          end
        end

      end
      alias :included :registered
    end
  end
end
