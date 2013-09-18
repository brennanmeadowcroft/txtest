desc "deploy the precompiled assets"
namespace :db do
	task :load_db_yml, :roles => [ :db ] do
		run_locally "cd config && tar -czf database.tar.gz database.yml"
		top.upload("config/database.tar.gz", "#{shared_path}/config", :via => :scp)
		run "cd #{shared_path}/config && tar -xzf database.tar.gz && rm database.tar.gz"
		# x = Extract, z = Gzip, f = Next item is file name to be unzipped
		run_locally "rm config/database.tar.gz"
	end

	task :symlink_db_yml, :roles => [ :db ] do
		run "cd #{shared_path}/config"
		run "ls -sf ~/#{shared_path}/config/database.yml ~/#{current_path}/config/"
	end

	task :load_schema, :roles => [ :db ] do
		# Navigate to current release
		run "cd ~/#{current_path}"

		#run rake task to load schema
		run "rake RAILS_ENV=production db:load:schema"
	end
end