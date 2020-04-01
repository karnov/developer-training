CONTACT_REGEX = %r{
  name:\s+(?<name>[\w\s]+)\s+        # name:    John Best
  address:\s+(?<address>[\w\s]+)\s+  # address: Mystreet 2
  phone:\s+(?<phone>\d{8})           # phone:   12345678
}x

contact = <<~txt
  name:      John Best
  address:   Megastreet 120
  phone:     24657890
txt
phone = contact[CONTACT_REGEX, :phone]

# or ...
phone, name, address = CONTACT_REGEX
  .match(contact)
  .values_at(:phone, :name, :address)

puts "Phone is '#{phone}', name is '#{name}'"