require 'rails_helper'

RSpec.describe 'Chats API', type: :request do
  describe "POST /api/v1/chats" do
    context "with valid parameters" do
        let(:test_user1_params) do
            {
               user: {
                username: "Test_User1",
                password: "Test1234@"
              }
            }
        end
        let(:test_user2_params) do
        {
            user: {
            username: "Test_User2",
            password: "Test1234@"
            }
        }
        end
        let(:new_msg_params) do
            {
               chat: {
                receiver: "Test_User2",
                message: "This is my test message."
              }
            }
        end

        it "sends message from test user1 to test user2" do
            expect { post "/api/v1/users", params: test_user2_params }.to change(User, :count).by(+1)
            expect { post "/api/v1/users", params: test_user1_params }.to change(User, :count).by(+1)
            expect { post "/api/v1/chats", params: new_msg_params}.to change(Chat, :count).by(+1)
            expect(response).to have_http_status :ok
            expect(JSON.parse(response.body)["message"]).to eq("Message sent")
            expect(JSON.parse(response.body)["data"]["message"]).to eq(new_msg_params[:chat][:message])
            expect(JSON.parse(response.body)["data"]["read"]).to eq(false)
        end

        it "attempts to send message from test user1 to non-existing user" do
            expect { post "/api/v1/users", params: test_user1_params }.to change(User, :count).by(+1)
            post "/api/v1/chats", params: new_msg_params
            expect(response).to have_http_status :bad_request
            expect(JSON.parse(response.body)["message"]).to eq("Receiver profile does not exist")
        end
    end
    context "with valid parameters" do
        let(:test_user1_params) do
            {
               user: {
                username: "Test_User1",
                password: "Test1234@"
              }
            }
        end
        let(:test_user2_params) do
        {
            user: {
            username: "Test_User2",
            password: "Test1234@"
            }
        }
        end
        let(:new_msg_params) do
            {
               chat: {
                receiver: "Test_User2",
                message: " "
              }
            }
        end
        
        it "attempts to send message from test user1 to test user with invalid params/blank message" do
            expect { post "/api/v1/users", params: test_user2_params }.to change(User, :count).by(+1)
            expect { post "/api/v1/users", params: test_user1_params }.to change(User, :count).by(+1)
            post "/api/v1/chats", params: new_msg_params
            expect(response).to have_http_status :unprocessable_entity
        end
    end

    describe "GET /api/v1/chats" do
        context "with valid parameters" do
            let(:test_user1_params) do
                {
                   user: {
                    username: "Test_User1",
                    password: "Test1234@"
                  }
                }
            end
              let(:test_user2_params) do
                {
                   user: {
                    username: "Test_User2",
                    password: "Test1234@"
                  }
                }
            end
            let(:new_msg_params) do
                {
                   chat: {
                    receiver: "Test_User2",
                    message: "This is my test message."
                  }
                }
            end
            let(:sender_params) do
                {
                   chat: {
                    sender: "Test_User1"
                  }
                }
            end

            it "checks messages sent from test user1 to test user2" do
                expect { post "/api/v1/users", params: test_user2_params }.to change(User, :count).by(+1)
                expect { post "/api/v1/users", params: test_user1_params }.to change(User, :count).by(+1)
                expect { post "/api/v1/chats", params: new_msg_params}.to change(Chat, :count).by(+1)
                post "/api/v1/users", params: test_user2_params
                get "/api/v1/chats", params: sender_params
                expect(response).to have_http_status :ok
                expect(JSON.parse(response.body)["message"]).to eq("Messages retrieved")
                get "/api/v1/chats", params: sender_params
                expect(response).to have_http_status :ok
                # Retrieved messages are then saved in DB as 'read == true' and will no longer show
                expect(JSON.parse(response.body)["message"]).to eq("You have no messages")
            end
        end

    end
  end
end