require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/fish", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Fish. As you add validations to Fish, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Fish.create! valid_attributes
      get fish_index_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      fish = Fish.create! valid_attributes
      get fish_url(fish)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_fish_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      fish = Fish.create! valid_attributes
      get edit_fish_url(fish)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Fish" do
        expect {
          post fish_index_url, params: { fish: valid_attributes }
        }.to change(Fish, :count).by(1)
      end

      it "redirects to the created fish" do
        post fish_index_url, params: { fish: valid_attributes }
        expect(response).to redirect_to(fish_url(Fish.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Fish" do
        expect {
          post fish_index_url, params: { fish: invalid_attributes }
        }.to change(Fish, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post fish_index_url, params: { fish: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested fish" do
        fish = Fish.create! valid_attributes
        patch fish_url(fish), params: { fish: new_attributes }
        fish.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the fish" do
        fish = Fish.create! valid_attributes
        patch fish_url(fish), params: { fish: new_attributes }
        fish.reload
        expect(response).to redirect_to(fish_url(fish))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        fish = Fish.create! valid_attributes
        patch fish_url(fish), params: { fish: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested fish" do
      fish = Fish.create! valid_attributes
      expect {
        delete fish_url(fish)
      }.to change(Fish, :count).by(-1)
    end

    it "redirects to the fish list" do
      fish = Fish.create! valid_attributes
      delete fish_url(fish)
      expect(response).to redirect_to(fish_index_url)
    end
  end
end
