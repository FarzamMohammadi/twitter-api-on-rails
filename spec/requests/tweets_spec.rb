require 'rails_helper'

RSpec.describe 'Tweets API', type: :request do
    describe "POST /api/v1/tweets" do
        context "with valid parameters" do
            let(:test_user1_params) do
                {
                   user: {
                    username: "Test_User1",
                    password: "Test1234@"
                  }
                }
            end
            let(:tweet_params) do
                {
                   tweet: {
                    description: "This is my test tweet."
                  }
                }
            end

            it "creates tweet" do
                expect { post "/api/v1/users", params: test_user1_params }.to change(User, :count).by(+1)
                expect { post "/api/v1/tweets", params: tweet_params}.to change(Tweet, :count).by(+1)
                expect(response).to have_http_status :created
                expect(JSON.parse(response.body)["message"]).to eq("Tweet sent")
                expect(JSON.parse(response.body)["data"]["description"]).to eq(tweet_params[:tweet][:description])
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
            let(:invalid_tweet_params) do
                {
                   tweet: {
                    description: "  "
                  }
                }
            end

            it "attempts to create tweet" do
                expect { post "/api/v1/users", params: test_user1_params }.to change(User, :count).by(+1)
                post "/api/v1/tweets", params: invalid_tweet_params
                expect(response).to have_http_status :unprocessable_entity
                expect(JSON.parse(response.body)["message"]).to eq("Tweet cannot be blank")
            end
        end

        describe "GET /api/v1/tweets" do
            context "with valid parameters" do
                let(:test_user1_params) do
                    {
                       user: {
                        username: "Test_User1",
                        password: "Test1234@"
                      }
                    }
                end
                let(:tweet_params) do
                    {
                       tweet: {
                        description: "This is my test tweet."
                      }
                    }
                end
    
                it "retrieves tweet" do
                    expect { post "/api/v1/users", params: test_user1_params }.to change(User, :count).by(+1)
                    expect { post "/api/v1/tweets", params: tweet_params}.to change(Tweet, :count).by(+1)
                    get "/api/v1/tweets", params: tweet_params
                    expect(response).to have_http_status :ok
                    expect(JSON.parse(response.body)["message"]).to eq("Tweets retrieved")
                    expect(JSON.parse(response.body)["data"][0]["description"]).to eq(tweet_params[:tweet][:description])
                end
            end
        end

        describe "PUT /api/v1/tweets" do
            context "with authorized user" do
                let(:test_user1_params) do
                    {
                       user: {
                        username: "Test_User1",
                        password: "Test1234@"
                      }
                    }
                end
                let(:tweet_params) do
                    {
                       tweet: {
                        description: "This is my test tweet."
                      }
                    }
                end
                let(:updated_tweet_params) do
                    {
                       tweet: {
                        description: "This is my updated test tweet."
                      }
                    }
                end
    
                it "updates tweet" do
                    expect { post "/api/v1/users", params: test_user1_params }.to change(User, :count).by(+1)
                    expect { post "/api/v1/tweets", params: tweet_params}.to change(Tweet, :count).by(+1)
                    put "/api/v1/tweets/" + JSON.parse(response.body)["data"]["id"].to_s, params: updated_tweet_params
                    expect(response).to have_http_status :ok
                    expect(JSON.parse(response.body)["message"]).to eq("Tweet updated")
                    expect(JSON.parse(response.body)["data"]["description"]).to eq(updated_tweet_params[:tweet][:description])
                end
            end

            context "with unauthorized user" do
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
                let(:tweet_params) do
                    {
                       tweet: {
                        description: "This is my test tweet."
                      }
                    }
                end
                let(:updated_tweet_params) do
                    {
                       tweet: {
                        description: "This is my updated test tweet."
                      }
                    }
                end
    
                it "attempts to update tweet" do
                    expect { post "/api/v1/users", params: test_user1_params }.to change(User, :count).by(+1)
                    expect { post "/api/v1/tweets", params: tweet_params}.to change(Tweet, :count).by(+1)
                    tweet_id = JSON.parse(response.body)["data"]["id"].to_s
                    expect { post "/api/v1/users", params: test_user2_params }.to change(User, :count).by(+1)
                    put "/api/v1/tweets/" + tweet_id, params: updated_tweet_params
                    expect(response).to have_http_status :unauthorized
                    expect(JSON.parse(response.body)["message"]).to eq("You do not have permission")
                end
            end
        end

        describe "DELETE /api/v1/tweets" do
            context "with authorized user" do
                let(:test_user1_params) do
                    {
                       user: {
                        username: "Test_User1",
                        password: "Test1234@"
                      }
                    }
                end
                let(:tweet_params) do
                    {
                       tweet: {
                        description: "This is my test tweet."
                      }
                    }
                end
    
                it "deletes tweet" do
                    expect { post "/api/v1/users", params: test_user1_params }.to change(User, :count).by(+1)
                    expect { post "/api/v1/tweets", params: tweet_params}.to change(Tweet, :count).by(+1)
                    delete "/api/v1/tweets/" + JSON.parse(response.body)["data"]["id"].to_s
                    expect(response).to have_http_status :ok
                    expect(JSON.parse(response.body)["message"]).to eq("Tweet deleted")
                    expect(JSON.parse(response.body)["data"]["description"]).to eq(tweet_params[:tweet][:description])
                end
            end

            context "with unauthorized user" do
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
                let(:tweet_params) do
                    {
                       tweet: {
                        description: "This is my test tweet."
                      }
                    }
                end

    
                it "attempts to delete tweet" do
                    expect { post "/api/v1/users", params: test_user1_params }.to change(User, :count).by(+1)
                    expect { post "/api/v1/tweets", params: tweet_params}.to change(Tweet, :count).by(+1)
                    tweet_id = JSON.parse(response.body)["data"]["id"].to_s
                    expect { post "/api/v1/users", params: test_user2_params }.to change(User, :count).by(+1)
                    delete "/api/v1/tweets/" + tweet_id
                    expect(response).to have_http_status :unauthorized
                    expect(JSON.parse(response.body)["message"]).to eq("You do not have permission")
                end
            end
        end

    end
end
