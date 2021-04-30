class <%= migration_class_name %> < ActiveRecord::Migration[<%= ActiveRecord::Migration.current_version %>]
  def self.up
    create_table :motor_queries, force: true do |t|
      t.column :name, :string, null: false
      t.column :description, :string
      t.column :sql_body, :string, null: false
      t.column :preferences, :string, null: false, default: '{}'
      t.column :author_id, :integer
      t.column :author_type, :string
      t.column :deleted_at, :datetime

      t.timestamps

      t.index :updated_at
      t.index 'lower(name)',
        name: 'motor_queries_lower_name_unique_index',
        unique: true,
        where: 'deleted_at IS NULL'
    end

    create_table :motor_dashboards, force: true do |t|
      t.column :title, :string, null: false
      t.column :description, :string
      t.column :preferences, :string, null: false, default: '{}'
      t.column :author_id, :integer
      t.column :author_type, :string
      t.column :deleted_at, :datetime

      t.timestamps

      t.index :updated_at
      t.index 'lower(title)',
        name: 'motor_dashboards_lower_title_unique_index',
        unique: true,
        where: 'deleted_at IS NULL'
    end

    create_table :motor_forms, force: true do |t|
      t.column :name, :string, null: false
      t.column :description, :string
      t.column :api_path, :string, null: false
      t.column :http_method, :string, null: false
      t.column :preferences, :string, null: false, default: '{}'
      t.column :author_id, :integer
      t.column :author_type, :string
      t.column :deleted_at, :datetime

      t.timestamps

      t.index :updated_at
      t.index 'lower(name)',
        name: 'motor_forms_lower_name_unique_index',
        unique: true,
        where: 'deleted_at IS NULL'
    end

    create_table :motor_resources, force: true do |t|
      t.column :name, :string, null: false, index: { unique: true }
      t.column :preferences, :string, null: false, default: '{}'

      t.timestamps

      t.index :updated_at
    end

    create_table :motor_configs, force: true do |t|
      t.column :key, :string, null: false, index: { unique: true }
      t.column :value, :string, null: false, default: '{}'

      t.timestamps

      t.index :updated_at
    end

    create_table :motor_alerts, force: true do |t|
      t.references :query, null: false, foreign_key: { to_table: :motor_queries }, index: true
      t.column :name, :string, null: false
      t.column :description, :string
      t.column :to_emails, :string, null: false
      t.column :is_enabled, :boolean, null: false, default: true
      t.column :preferences, :string, null: false, default: '{}'
      t.column :author_id, :integer
      t.column :author_type, :string
      t.column :deleted_at, :datetime

      t.timestamps

      t.index :updated_at
      t.index 'lower(name)',
        name: 'motor_alerts_lower_name_unique_index',
        unique: true,
        where: 'deleted_at IS NULL'
    end

    create_table :motor_alert_locks, force: true do |t|
      t.references :alert, null: false, foreign_key: { to_table: :motor_alerts }
      t.column :lock_timestamp, :string, null: false

      t.timestamps

      t.index %i[alert_id lock_timestamp], unique: true
    end

    create_table :motor_tags, force: true do |t|
      t.column :name, :string, null: false

      t.timestamps

      t.index 'lower(name)',
        name: 'motor_tags_lower_name_unique_index',
        unique: true
    end

    create_table :motor_taggable_tags, force: true do |t|
      t.references :tag, null: false, foreign_key: { to_table: :motor_tags }, index: true
      t.column :taggable_id, :integer, null: false
      t.column :taggable_type, :string, null: false

      t.index %i[taggable_id taggable_type tag_id],
        name: 'motor_polymorphic_association_tag_index',
        unique: true
    end
  end

  def self.down
    drop_table :motor_alert_locks
    drop_table :motor_alerts
    drop_table :motor_taggable_tags
    drop_table :motor_tags
    drop_table :motor_resources
    drop_table :motor_configs
    drop_table :motor_queries
    drop_table :motor_dashboards
  end
end