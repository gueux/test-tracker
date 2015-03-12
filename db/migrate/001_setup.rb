class Setup < ActiveRecord::Migration
  def change
    create_table "departments", :force => true do |t|
      t.column "name", :string, :limit => 30, :default => "", :null => false
    end

    create_table "staff", :force => true do |t|
      t.column "login", :string, :limit => 30, :default => "", :null => false
      t.column "hashed_password", :string, :limit => 40, :default => "", :null => false
      t.column "name", :string, :limit => 30, :default => "", :null => false
      t.column "mail", :string, :limit => 30, :default => "", :null => false
      t.column "department_id", :integer, :default => 1, :null => false
      t.column "admin", :boolean, :default => false, :null => false
    end

    create_table "customers", :force => true do |t|
      t.column "name", :string, :limit => 30, :default => "", :null => false
      t.column "mail", :string, :limit => 30, :default => "", :null => false
    end

    create_table "issue_statuses", :force => true do |t|
      t.column "name", :string, :limit => 30, :default => "", :null => false
      t.column "is_closed", :boolean, :default => false, :null => false
      t.column "is_default", :boolean, :default => false, :null => false
    end
    
    create_table "issues", :force => true do |t|
      t.column "public_id", :string, :limit => 17, :null => false
      t.column "subject", :string, :default => "", :null => false
      t.column "description", :text
      t.column "department_id", :integer, :default => 1, :null => false
      t.column "status_id", :integer, :default => 0, :null => false
      t.column "assigned_to_id", :integer
      t.column "author_id", :integer, :default => 0, :null => false
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end
    
    add_index "issues", ["public_id"], :name => "issues_public_id"

    create_table :history, :force => true do |t|
      t.column "issue_id", :integer, :default => 0, :null => false
      t.column "author", :string, :limit => 30, :null => false
      t.column "notes", :text
      t.column "created_on", :datetime, :null => false
    end

  end
end
