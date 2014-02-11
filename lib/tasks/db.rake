namespace :db do

	task :sync do
		remote_db = Rails.application.config.database_configuration['production']
		local_db = Rails.application.config.database_configuration['development']

		user = 'gibson'
		host = '162.243.13.28'

		dump_path = '/tmp/spider_dump.sql'
		local_dump = '/tmp/spider_dump.sql'

		puts 'Syncing production database to local'
		# puts "mysqldump -h #{remote_db['host']} -u #{remote_db['username']} -p'#{remote_db['password']}' #{remote_db['database']} > #{dump_path}"
		`ssh -t #{user}@#{host} "
		mysqldump -h #{remote_db['host']} -u #{remote_db['username']} -p'#{remote_db['password']}' #{remote_db['database']} > #{dump_path}
		&& exit"`

		`scp #{user}@#{host}:#{dump_path} #{local_dump} &&
		mysql -h #{local_db['host']} -u #{local_db['username']} -p'#{local_db['password']}' #{local_db['database']} < #{local_dump} && 
		rm #{local_dump}
		`
	end

end
