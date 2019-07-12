require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Blogs API' do

  path '/blogs' do
    get 'Retrieves a blog' do
      tags 'Blogs'
      produces 'application/json'

      response '200', 'list of blogs' do
        schema type: :object,
          required: ["data"],
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                required: ["id", "type"],
                properties: {
                  id: { type: :integer },
                  type: { type: :string },
                  attributes: {
                    type: :object,
                    required: ["label"],
                    properties: {
                      label: { type: :string}
                    }
                  }
                }
              }
            }

          }

        let(:id) { FactoryBot.create(:blog).id }
        run_test!
      end
    end
  end
end
