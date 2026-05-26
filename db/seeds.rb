puts "Clearing old data..."
MaintenanceRecord.destroy_all
Equipment.destroy_all
Category.destroy_all

puts "Creating Categories..."
computing = Category.create!(name: "Computing")
optics = Category.create!(name: "Optics")
networking = Category.create!(name: "Networking")
electronics = Category.create!(name: "Electronics")

puts "Creating Equipment..."
# Computing
eq1 = Equipment.create!(name: "MacBook Pro", serial_number: "MAC-001", status: "in_use", category: computing)
eq2 = Equipment.create!(name: "Dell XPS 15", serial_number: "DEL-042", status: "available", category: computing)

# Optics
eq3 = Equipment.create!(name: "Electron Microscope", serial_number: "MIC-999", status: "maintenance", category: optics)
eq4 = Equipment.create!(name: "Laser Lens", serial_number: "LSR-123", status: "available", category: optics)

# Networking
eq5 = Equipment.create!(name: "Cisco Router", serial_number: "CIS-555", status: "in_use", category: networking)
eq6 = Equipment.create!(name: "Network Switch", serial_number: "NET-777", status: "available", category: networking)

# Electronics
eq7 = Equipment.create!(name: "Arduino Uno", serial_number: "ARD-001", status: "available", category: electronics)
eq8 = Equipment.create!(name: "Oscilloscope", serial_number: "OSC-022", status: "maintenance", category: electronics)

puts "Creating Maintenance Records..."

MaintenanceRecord.create!(description: "Replaced failing battery", performed_at: 2.days.ago, equipment: eq1)

MaintenanceRecord.create!(description: "Deep cleaned lenses", performed_at: 1.week.ago, equipment: eq3)
MaintenanceRecord.create!(description: "Calibrated focus alignment", performed_at: 1.day.ago, equipment: eq3)

MaintenanceRecord.create!(description: "Updated firmware to latest version", performed_at: 3.days.ago, equipment: eq5)
MaintenanceRecord.create!(description: "Replaced broken internal fan", performed_at: 1.month.ago, equipment: eq5)

puts "✅ Seeding Complete!"
puts "Categories: #{Category.count} (Expected 4)"
puts "Equipment: #{Equipment.count} (Expected 8)"
puts "Maintenance Records: #{MaintenanceRecord.count} (Expected 5)"