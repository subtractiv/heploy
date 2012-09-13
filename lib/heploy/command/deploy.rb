require 'git'
require 'heroku-api'
require 'rake'
require 'logger'

class Heploy::Command::Deploy
  class << self

    def staging(config, verbose)
      deploy_to config.staging_app_name,
                config.development_branch,
                config.staging_branch,
                config,
                verbose
    end

    private

    def deploy_to(app_name, from_branch_name, to_branch_name, config, verbose)
      if verbose
        @repo = Git.open Dir.pwd, :log => Logger.new(STDOUT)
      else
        @repo = Git.open Dir.pwd
      end
      @dev_branch = @repo.branch config.development_branch
      @from_branch_name = from_branch_name
      @to_branch_name = to_branch_name
      @from_branch = @repo.branch @from_branch_name
      @to_branch = @repo.branch @to_branch_name
      @heroku = heroku_client config.heroku_api_key
      @app_name = app_name

      @repo.checkout @to_branch
      @repo.merge @from_branch
      turn_maintenance_on
      tag_latest_commit
      push_to_heroku
      @heroku.post_ps @app_name, "rake db:migrate"
      @heroku.post_ps_restart @app_name
      turn_maintenance_off
      @repo.checkout @dev_branch
    end

    def heroku_client(api_key)
      Heroku::API.new api_key: api_key
    end

    def turn_maintenance_on
      @heroku.post_app_maintenance @app_name, '1'
      if @heroku.get_app_maintenance(@app_name).body['maintenance']
        puts "Turned maintenance mode on."
      else
        abandon_ship "Error: maintenance mode did not turn on."
      end
    end

    def turn_maintenance_off
      @heroku.post_app_maintenance @app_name, '0'
      if !@heroku.get_app_maintenance(@app_name).body['maintenance']
        puts "Turned maintenance mode off."
      else
        abandon_ship "Error: maintenance mode did not turn off."
      end
    end

    def tag_latest_commit
      release = @heroku.get_releases(@app_name).body.last["name"].gsub(/[[:alpha:]]/, "").to_i + 1
      commit = @repo.add_tag "#{@to_branch_name}-#{release}"
      puts "Tagged commit #{commit[0,7]} as #{@to_branch_name}-#{release}."
    rescue Git::GitExecuteError => details
      puts "Error: #{details.message.split(": ").last.capitalize}."
    end

    def push_to_heroku
      puts "Pushing #{@to_branch_name} branch to #{@app_name}."
      @repo.push @to_branch_name, "#{@to_branch_name}:master", true
      confirm_codebase_push
    rescue Git::GitExecuteError => details
      abandon_ship "Error: could not push to #{@to_branch_name}."
    end

    def confirm_codebase_push
      latest_local_commit = @repo.log.first.inspect[0,7]
      latest_heroku_commit = @heroku.get_releases(@app_name).body.last['commit']
      if latest_local_commit == latest_heroku_commit
        puts "Completed push successfully."
      else
        puts "Error: pushing to #{@app_name} wasn't successful.\n" +
             "------ Latest local commit: #{latest_local_commit}\n" +
             "------ Latest Heroku commit: #{latest_heroku_commit}"
      end
    end

    def abandon_ship(message)
      puts message
      exit
    end

  end
end