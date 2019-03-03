desc "This task is called by the Heroku scheduler add-on"
task :delete_all_user_table => :environment do
  User.delete_all
end
