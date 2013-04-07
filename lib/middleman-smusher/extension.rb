module Middleman
  module Smusher

    DEFAULT_THREADS = 32

    class << self
      def registered(app, options={})
        require 'smusher'

        # options[:service] ||= "SmushIt"
        options[:quiet] = true

        app.after_configuration do
          smush_dir    = options.fetch(:path, File.join(build_dir, images_dir))
          thread_count = options.fetch(:threads, DEFAULT_THREADS)
          prefix       = build_dir + File::SEPARATOR
        
          after_build do |builder|

            files = ::Smusher.class_eval do
              images_in_folder(smush_dir)
            end

            builder.say_status :smushing, "%d files. This may take a moment." % files.size

            queue = Queue.new
            files.each{|f| queue << f }

            mutex = Mutex.new
            threads = []

            thread_count.times do
              threads << Thread.new do
                loop do
                  break if queue.empty?
                  file = queue.pop(true)
                  break unless file

                  ::Smusher.optimize_image [file], options

                  mutex.synchronize{
                    builder.say_status :smushed, file.sub(prefix, '')
                  }
                end
              end
            end
            threads.each(&:join)

          end
        end

      end
      alias :included :registered

    end
  end
end