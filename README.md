[![Code Climate](https://codeclimate.com/github/jameszhan/ask-ruby.png)](https://codeclimate.com/github/jameszhan/ask-ruby)

ask-ruby
========

An idea project of Q&amp;A site use ruby implementation.

  Introduction
  
  
## Development Mode
  
###Load Sample Data
    
    rake db:drop
    rake db:seed
    
    
    
##Production Mode
    
###Deploy to EC2

    #ssh 
    cat ~/.ssh/id_rsa.pub | ssh -v -i ~/.ssh/xxx.pem ubuntu@ip_address 'cat >> ~/.ssh/authorized_keys'
    
    git checkout master
    #There is new machine do the scripts as following
    cap deploy:install
    cap deploy:setup
    cap deploy:cold
    
    #When there is any code update, you can run the following command to redeploy the new version.
    cap deploy
    