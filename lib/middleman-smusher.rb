require "middleman-core"

::Middleman::Extensions.register(:smusher) do
  require "middleman-smusher/extension"
  ::Middleman::Smusher
end
