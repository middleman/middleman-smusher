require 'middleman-core'

require 'middleman-smusher/version'
  
::Middleman::Extensions.register(:smusher) do
  require 'middleman-smusher/extension'
  ::Middleman::Smusher
end