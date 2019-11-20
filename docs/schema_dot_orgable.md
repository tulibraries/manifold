# Adding schema.org metadata via the `SchemaDotOrgable` concern.

The `SchemaDotOrgable` model concern allows you to define a mapping of your entity's data to schema.org attributes.

## Required 
When including `SchemaDotOrgable`, you *MUST* define a method `schema_dot_org_type` that returns a string of the schema.org type this will map to. For example, ActiveRecord entity event maps to https://schema.org/Event. The `schema_dot_org_type` should return `"Event"`.


## Adding Additional Attributes
You *MAY* also define addtional attributes by defining an `additional_schema_dot_org_attributes` method that returns a hash mapping schema.org types  to entity attributes or methods. For example, `{startDate: start_time}` maps the schema.org attribute `startDate` to the Event entity attribute `start_time`.

## Conditional Attributes
A common pattern for conditionally adding an attribute is to only set the value conditionally, like:
```ruby
image: (index_image_url if respond_to?(:index_image_url)),
```
SchemaDotOrgable compacts the hash before returning, so any keys with nil as the value will be removed.

## Adding it to the View

Once you ahve included `SchemaDotOrgable` into the model and defined your additional attributes, you need to add it to the show page for the entity, with a snippet like:
```html
<script type="application/ld+json">
  <%= json_ld(@building) %>
</script>
```