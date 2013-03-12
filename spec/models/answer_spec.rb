require 'spec_helper'

describe Answer do
  it {should respond_to(:body)}
  it {should validate_presence_of(:body)}
  it {should respond_to(:user_id)}
  it {should validate_presence_of(:user_id)}
  it {should respond_to(:question_id)}
  it {should validate_presence_of(:question_id)}
end
