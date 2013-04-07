module Middleman
  module Smusher

    DEFAULT_THREADS = 32

    class << self
      def registered(app, options={})
        require 'smusher'
        # options[:service] ||= "SmushIt"
        options[:quiet] = true

        app.after_configuration do
          smush_dir     = options.fetch(:path, File.join(build_dir, images_dir))
          thread_count  = options.fetch(:threads, DEFAULT_THREADS)
          in_parallel   = options.fetch(:parallel, true)
          prefix        = build_dir + File::SEPARATOR
        
          after_build do |builder|

            files = ::Smusher.class_eval do
              images_in_folder(smush_dir)
            end

            builder.say_status :smushing, "%d files. This may take a moment." % files.size

            if in_parallel
              # parallel smushing
              mutex = Mutex.new
              threads = []

              thread_count.times do
                threads << Thread.new do
                  loop do
                    file = nil
                    mutex.synchronize do
                      file = files.pop
                    end
                    break unless file

                    ::Smusher.optimize_image [file], options

                    mutex.synchronize do
                      builder.say_status :smushed, file.sub(prefix, '')
                    end
                  end
                end
              end
              threads.each(&:join)
            else
              # serial smushing
              files.each do |file|
                ::Smusher.optimize_image [file], options
                builder.say_status :smushed, file.sub(prefix, '')
              end
            end

          end
        end

      end
      alias :included :registered

    end
  end
end