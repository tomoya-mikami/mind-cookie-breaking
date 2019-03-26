class AddStatusToSource < ActiveRecord::Migration[5.2]
  def up
    add_column :sources, :status, :string
  end

  def down
    remove_column :sources, :status, :string
  end
end
