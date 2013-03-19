require 'spec_helper'

describe Notification do
	it { should respond_to(:read) }
	it { should respond_to(:source) }
	it { should validate_presence_of(:source) }
	it { should respond_to(:source_id) }
	it { should validate_presence_of(:source_id) }
	it { should respond_to(:user_id) }
	it { should validate_presence_of(:user) }
end
