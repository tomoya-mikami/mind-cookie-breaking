class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :token
      t.string :estimate_url
      t.string :auth_name
      t.string :auth_password
      t.integer :vertical
      t.integer :horizontal

      t.timestamps
    end
  end
end
