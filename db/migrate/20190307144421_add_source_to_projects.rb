class AddSourceToProjects < ActiveRecord::Migration[5.2]
  def change
    add_reference :sources, :project, foreign_key: true
  end
end
