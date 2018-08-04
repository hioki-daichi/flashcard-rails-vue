namespace :once do
  namespace :pages do
    desc 'Set sub to Page'
    task set_sub: :environment do
      ActiveRecord::Base.transaction do
        Page.find_each do |page|
          page.send(:set_sub)
          page.save!
        end
      end
    end
  end
end
