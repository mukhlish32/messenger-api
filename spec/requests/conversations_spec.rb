require "rails_helper"

RSpec.describe "Conversations API", type: :request do
  let(:dimas) { create(:user) }
  let(:dimas_headers) { valid_headers(dimas.id) }

  let(:samid) { create(:user) }
  let(:samid_headers) { valid_headers(samid.id) }

  describe "GET /conversations" do
    context "when user have no conversation" do
      # make HTTP get request before each example
      before {
        get "/conversations", params: {}, headers: dimas_headers
      }

      it "returns empty data with 200 code" do
        expect_response(:ok)
        expect(response_data).to be_empty
      end
    end

    context "when user have conversations" do
      # TODOS: Populate database with conversation of current user
      before do
        (1..5).each do |i|
          # Create conversation & message by dimas
          new_user = create(:user)
          conversation = create(:conversation, user: dimas, with_user: new_user)
          create(:chat_message, conversation: conversation, sender: dimas)
        end

        get "/conversations", params: {}, headers: dimas_headers
      end

      it "returns list conversations of current user" do
        # Note `response_data` is a custom helper
        # to get data from parsed JSON responses in spec/support/request_spec_helper.rb

        expect(response_data).not_to be_empty
        expect(response_data.size).to eq(5)
      end

      it "returns status code 200 with correct response" do
        # Validate the response
        expect_response(:ok)

        # Validate individual items in the response data
        response_data.each_with_index do |item, index|
          expect(item[:id]).to be_a(Integer)
          expect(item[:with_user][:id]).to be_a(Integer)
          expect(item[:with_user][:name]).to be_a(String)
          expect(item[:with_user][:photo_url]).to be_a(String)
          expect(item[:last_message][:id]).to be_a(Integer)
          expect(item[:last_message][:sender][:id]).to be_a(Integer)
          expect(item[:last_message][:sender][:name]).to be_a(String)
          expect(item[:last_message][:sent_at]).to be_a(String)
          expect(item[:unread_count]).to be_a(Integer)
        end
      end
    end
  end

  describe "GET /conversations/:id" do
    context "when the record exists" do
      # TODO: create conversation of dimas
      before do
        conversation = create(:conversation, user: dimas, with_user: samid)
        convo_id = conversation.id

        get "/conversations/#{convo_id}", params: {}, headers: dimas_headers
      end

      it "returns conversation detail" do
        expect_response(:ok)
        expect(response_data).to match(
          {
            id: Integer,
            with_user: {
              id: Integer,
              name: String,
              photo_url: String,
            },
          }
        )
      end
    end

    context "when current user access other user conversation" do
      before do
        new_user = create(:user)
        conversation = create(:conversation, user: dimas, with_user: new_user)
        convo_id = conversation.id

        get "/conversations/#{convo_id}", params: {}, headers: samid_headers
      end

      it "returns status code 403" do
        expect(response).to have_http_status(403)
      end
    end

    context "when the record does not exist" do
      before { get "/conversations/-11", params: {}, headers: dimas_headers }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end
    end
  end
end
