class PageSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :layout, :label
end
