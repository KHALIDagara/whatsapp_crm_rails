# Use a transaction to ensure all or no data is created.
ApplicationRecord.transaction do
  # Create the primary user if they don't exist.
  user = User.find_or_create_by!(email: 'khalidagara43@gmail.com') do |u|
    u.password = 'khalid1234'
    u.password_confirmation = 'khalid1234'
  end

  puts "✅ Seeding 20 contacts for user: #{user.email}"

  # Define an array of 20 manually created contacts.
  contacts_data = [
    { name: "Youssef Alaoui", whatsapp_number: "212661123456", country: "Morocco", status: :phase_1, notes: "Initial contact made.", tag_list: "lead, new, Casablanca" },
    { name: "Fatima Zahra", whatsapp_number: "212662234567", country: "Morocco", status: :pending, notes: "Awaiting response.", tag_list: "lead, follow-up, Rabat" },
    { name: "John Smith", whatsapp_number: "14155552671", country: "USA", status: :phase_3, notes: "Premium customer.", tag_list: "customer, vip, priority" },
    { name: "Marie Dubois", whatsapp_number: "33612345678", country: "France", status: :phase_2, notes: "Demo scheduled.", tag_list: "lead, demoed" },
    { name: "Ahmed Khan", whatsapp_number: "971501234567", country: "UAE", status: :customer, notes: "Signed up for basic plan.", tag_list: "customer" },
    { name: "Sofia Rossi", whatsapp_number: "393331234567", country: "Italy", status: :pending, notes: "From website form.", tag_list: "lead, new" },
    { name: "Liam O'Connell", whatsapp_number: "353871234567", country: "Ireland", status: :phase_1, notes: "Needs pricing info.", tag_list: "lead, inquiry" },
    # --- THIS LINE IS FIXED ---
    { name: "Aya Nakamura", whatsapp_number: "33712345678", country: "France", status: :customer, notes: "Repeat business.", tag_list: "customer, loyal" },
    { name: "Kenji Tanaka", whatsapp_number: "819012345678", country: "Japan", status: :phase_2, notes: "", tag_list: "lead, international" },
    { name: "Isabella Garcia", whatsapp_number: "5215512345678", country: "Mexico", status: :pending, notes: "Contact via referral.", tag_list: "lead, referral" },
    { name: "Nour Benali", whatsapp_number: "212663345678", country: "Morocco", status: :phase_3, notes: "Very satisfied client.", tag_list: "customer, vip, Casablanca" },
    { name: "David Chen", whatsapp_number: "16475551234", country: "Canada", status: :pending, notes: "", tag_list: "lead" },
    { name: "Fatou Diop", whatsapp_number: "221771234567", country: "Senegal", status: :phase_1, notes: "Met at conference.", tag_list: "lead, event" },
    { name: "Omar Sharif", whatsapp_number: "201001234567", country: "Egypt", status: :customer, notes: "", tag_list: "customer" },
    { name: "Emily White", whatsapp_number: "447800900123", country: "UK", status: :phase_2, notes: "Follow-up call needed.", tag_list: "lead, follow-up" },
    { name: "Amir Al-Fassi", whatsapp_number: "212650123456", country: "Morocco", status: :customer, notes: "Local business owner.", tag_list: "customer, Fes" },
    { name: "Chloe Müller", whatsapp_number: "4915112345678", country: "Germany", status: :pending, notes: "Downloaded e-book.", tag_list: "lead, marketing" },
    { name: "Santiago Vargas", whatsapp_number: "573101234567", country: "Colombia", status: :phase_1, notes: "", tag_list: "lead" },
    { name: "Layla Haddad", whatsapp_number: "212670123456", country: "Morocco", status: :phase_2, notes: "Considering team plan.", tag_list: "lead, priority, Marrakech" },
    { name: "Peter Jones", whatsapp_number: "13105551234", country: "USA", status: :customer, notes: "Tech industry.", tag_list: "customer, enterprise" }
  ]

  # Loop through the data and create contacts if they don't already exist.
  contacts_data.each do |data|
    contact = user.contacts.find_or_create_by!(whatsapp_number: data[:whatsapp_number]) do |c|
      c.name = data[:name]
      c.country = data[:country]
      c.status = data[:status]
      c.notes = data[:notes]
      c.tag_list = data[:tag_list]
    end
    puts "   -> Processed contact: #{contact.name}"
  end
end

puts "✅ Seeding complete."
