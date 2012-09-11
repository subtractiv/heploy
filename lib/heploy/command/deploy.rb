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
      from_branch = repo.branch from_branch_name
      to_branch = repo.branch to_branch_name
      heroku = heroku_client c
      release = heroku.get_releases(app_name).body.last["name"].gsub(/[[:alpha:]]/, "").to_i + 1
    end

    def heroku_client(c)
      Heroku::API.new api_key: c.heroku_api_key
    end

  end
end