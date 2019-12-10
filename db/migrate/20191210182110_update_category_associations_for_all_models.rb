# frozen_string_literal: true

class UpdateCategoryAssociationsForAllModels < ActiveRecord::Migration[5.2]
  def change
    @log = Logger.new("log/categoriaztions.log")
    cats = [Categorization]

    cats.each do |c|
      c.all.each do |a|
        a.with_lock do
          begin
            a.categorizable_type = "Webpage" if a.categorizable_type == "Page"
            a.save!
          rescue StandardError => e
            @log.send(:info, "Category ID: #{a.category_id}, Categorization ID: #{a.id} -- #{e.message}")
            next
          end
        end
      end
    end
  end
end
