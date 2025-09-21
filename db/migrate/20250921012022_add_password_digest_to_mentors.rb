class AddPasswordDigestToMentors < ActiveRecord::Migration[8.0]
  def change
    add_column :mentors, :password_digest, :string
  end
end
