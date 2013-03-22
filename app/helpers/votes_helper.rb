module VotesHelper
  
  def vote_button(direction, votable)
    if current_user && (vote = current_user.vote_on(votable))
      checked = (vote > 0 && direction == :up || vote < 0 && direction == :down) ? " checked" : ""
      button_tag "", class: "vote-#{direction}#{checked}", name: "vote_#{direction}"  
    else
      button_tag "", class: "vote-#{direction}", name: "vote_#{direction}"
    end
  end
  
end