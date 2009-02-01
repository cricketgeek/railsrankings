namespace :data_helpers do
  desc "slugify all coders"
  task :slugify => :environment do
    coders = Coder.all
    coders.each do |coder|
      coder.slug = "#{coder.full_name.gsub(" ","-").gsub(/[^a-zA-Z\-]/,"")}"
      puts "slugifying #{coder.full_name} to #{coder.slug}"
      coder.save
    end
  end
end