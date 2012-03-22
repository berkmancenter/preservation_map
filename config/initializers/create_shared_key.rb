shared_key_file = "#{Rails.root}/config/initializers/shared_key.rb"
unless File.exists?(shared_key_file)
  f = File.new(shared_key_file,'w',0740)
  f.write("SHARED_KEY_FOR_TASKS='#{SecureRandom.hex(32)}'")
  f.close
end
