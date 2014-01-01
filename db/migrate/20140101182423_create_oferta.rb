class CreateOferta < ActiveRecord::Migration
  def change
    create_table :oferta do |t|
      t.string :description
      t.date :start_date
      t.date :end_date
      t.integer :maximum_subscriptions
      t.string :course_code

      t.timestamps
    end
  end
end
