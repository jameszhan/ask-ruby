require 'spec_helper'

describe Notification do
	it { should respond_to(:read) }
	it { should respond_to(:source_type) }
	it { should validate_presence_of(:source_type) }
	it { should respond_to(:source_id) }
	it { should validate_presence_of(:source_id) }
	it { should respond_to(:user) }
	it { should validate_presence_of(:user_id) }
end
