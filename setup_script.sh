sudo apt update
pip install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib
sudo apt install ruby-dev ruby-bundler nodejs -y
sudo gem install smashing
# smashing new my_cool_dashboard && cd my_cool_dashboard
cd ./techmate_dash
bundle install 
smashing start

#screen -S my_dash -d -m smashing start

#curl -d '{ "auth_token": "YOUR_AUTH_TOKEN", "text": "Hey, Look what I can do!" }' [http://localhost:3030/widgets/welcome](http://localhost:3030/widgets/welcome)