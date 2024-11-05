require "rails_helper"

RSpec.describe FishController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/fish").to route_to("fish#index")
    end

    it "routes to #new" do
      expect(get: "/fish/new").to route_to("fish#new")
    end

    it "routes to #show" do
      expect(get: "/fish/1").to route_to("fish#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/fish/1/edit").to route_to("fish#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/fish").to route_to("fish#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/fish/1").to route_to("fish#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/fish/1").to route_to("fish#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/fish/1").to route_to("fish#destroy", id: "1")
    end
  end
end
