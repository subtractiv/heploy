require 'git'
require 'heroku-api'

class Heploy::Command::Deploy
  class << self

    def staging(c)
      deploy_to c.staging_app_name,
                c.development_branch,
                c.staging_branch,
                c
    end

    private

    def deploy_to(app_name, from_branch_name, to_branch_name, c)
      repo = Git.open Dir.pwd
      dev_branch = repo.branch c.development_branch
      from_branch = repo.branch from_branch_name
      to_branch = repo.branch to_branch_name
      heroku = heroku_client c.heroku_api_key

      repo.checkout to_branch
      repo.merge from_branch
      turn_maintenance_on heroku, app_name
      tag_latest_commit(repo, heroku, app_name, to_branch_name)
      push_to_heroku(repo, to_branch_name)
      Rake::Task["db:migrate"]
      heroku.post_ps_restart app_name
      heroku.post_app_maintenance app_name, '0'
      repo.checkout dev_branch
    end

    def heroku_client(api_key)
      Heroku::API.new api_key: api_key
    end

    def turn_maintenance_on(heroku, app_name)
      heroku.post_app_maintenance app_name, '1'
      if heroku.get_app_maintenance(app_name).body['maintenance']
        puts "Turned maintenance mode on."
      else
        puts "Error: maintenance mode did not turn on."
        exit
      end
    end

    def tag_latest_commit(repo, heroku, app_name, to_branch_name)
      release = heroku.get_releases(app_name).body.last["name"].gsub(/[[:alpha:]]/, "").to_i + 1
      repo.add_tag "#{to_branch_name}-#{release}"
      puts "Tagged commit __ as #{to_branch_name}-#{release}."
    rescue Git::GitExecuteError => details
      puts "Error: #{details.message.split(": ").last.capitalize}."
    end

    def push_to_heroku(repo, to_branch_name)
      repo.push to_branch_name, "#{to_branch_name}:master", true
    rescue Git::GitExecuteError => details
      puts "Error: could not push to #{to_branch_name}."
      exit
    end

  end
end