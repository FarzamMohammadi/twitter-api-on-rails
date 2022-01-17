require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe "POST /api/v1/users" do   
    context "with valid parameters" do
      let(:valid_params) do
        {
           user: {
            username: "Test_User",
            password: "Test1234@"
          }
        }
      end
      let(:wrong_password_params) do
        {
           user: {
            username: "Test_User",
            password: "123"
          }
        }
      end

      it "creates and logs in new user" do
        expect { post "/api/v1/users", params: valid_params }.to change(User, :count).by(+1)
        expect(response).to have_http_status :created
        expect(JSON.parse(response.body)["message"]).to eq("User added")
        expect(session[:user]).to eq(valid_params[:user][:username])
      end

      it "attempts to log in with incorrect password" do
        expect { post "/api/v1/users", params: valid_params }.to change(User, :count).by(+1)
        post "/api/v1/users", params: wrong_password_params
        expect(response).to have_http_status :unauthorized
        expect(JSON.parse(response.body)["message"]).to eq("Could not log in")
      end

      it "logs in with correct password" do
        expect { post "/api/v1/users", params: valid_params }.to change(User, :count).by(+1)
        post "/api/v1/users", params: valid_params
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)["message"]).to eq("Login successful")
      end
    end
    
    context "with invalid parameters" do
      let(:invalid_params) do
        {
           user: {
            username: "Test_User2",
            password: "123"
          }
        }
      end
      let(:no_username_params) do
        {
           user: {
            password: "123"
          }
        }
      end

      it "attempts to create user with invalid password" do
        post "/api/v1/users", params: invalid_params
        expect(response).to have_http_status :unprocessable_entity
        expect(JSON.parse(response.body)["data"]["password"]).to eq(["is invalid"])
      end
      it "attempts to create user with no username" do
        post "/api/v1/users", params: no_username_params
        expect(response).to have_http_status :unprocessable_entity
        expect(JSON.parse(response.body)["data"]["password"]).to eq(["is invalid"])
        expect(JSON.parse(response.body)["data"]["username"]).to eq(["can't be blank"])
      end
    end

  end
end
