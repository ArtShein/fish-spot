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

RSpec.describe "/trips", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Session. As you add validations to Session, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Session.create! valid_attributes
      get trips_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      trip = Trip.create! valid_attributes
      get trip_url(trip)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_trip_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      trip = Trip.create! valid_attributes
      get edit_trip_url(trip)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Session" do
        expect {
          post sessions_url, params: { session: valid_attributes }
        }.to change(Session, :count).by(1)
      end

      it "redirects to the created session" do
        post sessions_url, params: { session: valid_attributes }
        expect(response).to redirect_to(session_url(Session.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Session" do
        expect {
          post sessions_url, params: { session: invalid_attributes }
        }.to change(Session, :count).by(0)
      end


      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post sessions_url, params: { session: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested session" do
        session = Session.create! valid_attributes
        patch session_url(session), params: { session: new_attributes }
        session.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the session" do
        session = Session.create! valid_attributes
        patch session_url(session), params: { session: new_attributes }
        session.reload
        expect(response).to redirect_to(session_url(session))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        session = Session.create! valid_attributes
        patch session_url(session), params: { session: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested session" do
      session = Session.create! valid_attributes
      expect {
        delete session_url(session)
      }.to change(Session, :count).by(-1)
    end

    it "redirects to the trips list" do
      session = Session.create! valid_attributes
      delete session_url(session)
      expect(response).to redirect_to(sessions_url)
    end
  end
end
