class RenamePasswordToHashedPassword < ActiveRecord::Migration
  # Renaming the password field's name to hashed_password. Because we long to encrypt
  # by hash encrypting.
  def change
    rename_column :users, :password, :hashed_password
  end
end
