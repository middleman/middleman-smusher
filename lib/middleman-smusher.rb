module Middleman
  module Features
    module Smusher
      class << self
        def registered(app)
          require "smusher"
          
          app.after_build do          
            smush_dir = File.join(app.build_dir, app.images_dir)
          
            files = ::Smusher.class_eval do
              images_in_folder(smush_dir)
            end
          
            files.each do |file|
              ::Smusher.optimize_image(
                [file],
                { :service => 'PunyPng', :quiet => true }
              )
              
              say_status :smushed, file.gsub(app.build_dir+"/", "")
            end
          end
        end  
        alias :included :registered
      end
    end
  end
end