# Database migrations
# creates and adds messages to the database. Includes the message_content and timestamps columns

class AddMessages < ActiveRecord::Migration[7.0]
  # this migration will modify the database schema
  def change
    # this line creates a new table named device_messages
    create_table :device_messages do |t|
      # adds a jsonb column to the table named message_content
      t.json :message_content
      # adds a column to the table with created_at and updated_at timestamps which are written automatically by Rails. Changed from.jsonb to t.json
      t.timestamps
    end
  end
end
