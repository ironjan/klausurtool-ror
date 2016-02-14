require 'rails_helper'

describe ApplicationController do

	it "returns the index when required" do
		get :index
		expect(response).to render_template(:index)
	end
end
