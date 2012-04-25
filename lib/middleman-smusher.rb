require "middleman-core"

require "middleman-smusher/version"
  
::Middleman::Extensions.register(:smusher, ">= 3.0.0.beta.2") do
  require "middleman-smusher/extension"
  ::Middleman::Smusher
end