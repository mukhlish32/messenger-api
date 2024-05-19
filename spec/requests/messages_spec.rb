require "rails_helper"

RSpec.describe "Messages API", type: :request do
  let(:agus) { create(:user, name: "Agus") }
  let(:dimas) { create(:user, name: "Dimas") }
  let(:dimas_headers) { valid_headers(dimas.id) }

  let(:samid) { create(:user) }
  let(:samid_headers) { valid_headers(samid.id) }
  let(:conversation) { create(:conversation, user: dimas, with_user: agus) }
  let(:convo_id) { conversation.id }

  describe "get list of messages" do
    context "when user have conversation with other user" do
      before do
        conversation
        5.times do |i|
          sender = i.even? ? conversation.user : conversation.with_user
          message = Faker::Lorem.sentence
          create(:chat_message, conversation: conversation, sender: sender, message: message, read_at: nil)
        end
        get "/conversations/#{convo_id}/messages", headers: dimas_headers
      end

      it "returns list all messages in conversation" do
        expect_response(:ok)
        expect(response_data[0]).to match(
          {
            id: Integer,
            message: String,
            sender: {
              id: Integer,
              name: String,
            },
            sent_at: String,
          }
        )
      end
    end

    context "when user try to access conversation not belong to him" do
      before do
        conversation
        5.times do |i|
          sender = i.even? ? conversation.user : conversation.with_user
          message = Faker::Lorem.sentence
          create(:chat_message, conversation: conversation, sender: sender, message: message, read_at: nil)
        end
        get "/conversations/#{convo_id}/messages", headers: samid_headers
      end

      it "returns error 403" do
        expect_response(:forbidden)
      end
    end

    context "when user try to access invalid conversation" do
      before { get "/conversations/-11/messages", headers: samid_headers }

      it "returns error 404" do
        expect_response(:not_found)
      end
    end
  end

  describe "send message" do
    let(:valid_attributes) do
      { message: "Hi there!", user_id: agus.id, conversation_id: convo_id }
    end

    let(:invalid_attributes) do
      { message: "", user_id: agus.id, conversation_id: convo_id }
    end

    context "when request attributes are valid" do
      before { post "/messages", params: valid_attributes.to_json, headers: dimas_headers }

      it "returns status code 201 (created) and create conversation automatically" do
        expect_response(:created)
        expect(response_data).to match(
          {
            id: Integer,
            message: String,
            sender: {
              id: Integer,
              name: String,
            },
            sent_at: String,
            conversation: {
              id: Integer,
              with_user: {
                id: Integer,
                name: String,
                photo_url: String,
              },
            },
          }
        )
      end
    end

    context "when create message into existing conversation" do
      before { post "/messages", params: valid_attributes.to_json, headers: dimas_headers }

      it "returns status code 201 (created) and create conversation automatically" do
        expect_response(:created)
        expect(response_data).to match(
          {
            id: Integer,
            message: String,
            sender: {
              id: Integer,
              name: String,
            },
            sent_at: String,
            conversation: {
              id: Integer,
              with_user: {
                id: Integer,
                name: String,
                photo_url: String,
              },
            },
          }
        )
      end
    end

    context "when an invalid request" do
      before { post "/messages", params: invalid_attributes.to_json, headers: dimas_headers }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
    end
  end
end
