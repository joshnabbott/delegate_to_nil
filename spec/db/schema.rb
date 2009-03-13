ActiveRecord::Schema.define(:version => 0) do
  create_table :people, :force => true do |t|
    t.string :name
  end

  create_table :billing_addresses, :force => true do |t|
    t.belongs_to :person
    t.string :address_one
  end
end