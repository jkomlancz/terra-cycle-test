# Required GEM(s)
    gem install json
    gem install rest-client
    gem install awesome_print
# Run
### Default
You can check de default (rails/rails) repository
    ruby main.rb
### With arg
You can specify which repository you want to check

#### Usable arg(s)
    -u %USER%         --> github user (the repository owner)
    -r %REPOSITORY%   --> the repository name
    -auth             --> GitHub limits the requests, but if you authenticate yourself GitHub increases the limit.
                          If you use this arg the program will ask you to enter  GitHub profile username, password
