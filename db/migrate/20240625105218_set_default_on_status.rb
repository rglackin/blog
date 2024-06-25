class SetDefaultOnStatus < ActiveRecord::Migration[7.1]
  def change
    change_column_default :articles, :status, "public"
    change_column_default :comments, :status, "public"
  end
end
