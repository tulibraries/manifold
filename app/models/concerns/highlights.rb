module Highlights
  extend ActiveSupport::Concern

  included do
   @highlights = ::Highlight.find_by(promoted: true)
   binding.pry
  end
end
