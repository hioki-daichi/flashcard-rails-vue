namespace :once do
  namespace :books do
    desc "Set sub to Book"
    task set_sub: :environment do
      ActiveRecord::Base.transaction do
        Book.find_each do |book|
          book.send(:set_sub)
          book.save!
        end
      end
    end
  end
end
