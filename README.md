[![Code Climate](https://codeclimate.com/github/jameszhan/ask-ruby.png)](https://codeclimate.com/github/jameszhan/ask-ruby)

ask-ruby
========

An idea project of Q&amp;A site use ruby implementation.

  Introduction
  
  
###Load Sample Data
    
    rake db:drop
    rake db:seed
    
    
    
###Deploy to EC2

    #ssh without password
    cat ~/.ssh/id_rsa.pub | ssh -v -i ~/.ssh/trail.pem ubuntu@ec2-54-244-136-78.us-west-2.compute.amazonaws.com 'cat >> ~/.ssh/authorized_keys'
    
    cap deploy:install