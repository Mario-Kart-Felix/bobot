require 'rails_helper'
require 'helpers/graph_api_helpers'

RSpec.describe Bobot::Profile do
  let(:access_token) { 'access token' }

  let(:messenger_profile_url) do
    Bobot::Profile.base_uri + '/messenger_profile'
  end

  before do
    Bobot.page_access_token = access_token
  end

  describe '.set' do
    context 'with a successful response' do
      before do
        stub_request(:post, messenger_profile_url)
          .with(
            query: {
              access_token: access_token
            },
            headers: default_graph_api_response_headers,
            body: JSON.dump(
              get_started: {
                payload: 'GET_STARTED_PAYLOAD'
              }
            )
          )
          .to_return(
            body: JSON.dump(
              result: 'Successfully added Get Started button'
            ),
            status: :ok,
            headers: default_graph_api_response_headers
          )
      end

      let :options do
        {
          get_started: {
            payload: 'GET_STARTED_PAYLOAD'
          }
        }
      end

      it 'returns true' do
        expect(subject.set(options, access_token: access_token)).to be(true)
      end
    end

    context 'with an unsuccessful response' do
      let(:error_message) { 'Invalid OAuth access token.' }

      before do
        stub_request(:post, messenger_profile_url)
          .with(query: { access_token: access_token })
          .to_return(
            body: JSON.dump(
              'error' => {
                'message' => error_message,
                'type' => 'OAuthException',
                'code' => 190,
                'fbtrace_id' => 'Hlssg2aiVlN'
              }
            ),
            status: :ok,
            headers: default_graph_api_response_headers
          )
      end

      it 'raises an error' do
        expect do
          options = {
            get_started: {
              payload: 'GET_STARTED_PAYLOAD'
            }
          }
          subject.set(options, access_token: access_token)
        end.to raise_error(Bobot::AccessTokenError)
      end
    end
  end

  describe '.unset' do
    context 'with a successful response' do
      before do
        stub_request(:delete, messenger_profile_url)
          .with(
            query: {
              access_token: access_token
            },
            headers: default_graph_api_response_headers,
            body: JSON.dump(
              fields: [
                'get_started'
              ]
            )
          )
          .to_return(
            body: JSON.dump(
              result: 'Successfully deleted Get Started button'
            ),
            status: :ok,
            headers: default_graph_api_response_headers
          )
      end

      let :options do
        {
          fields: [
            'get_started'
          ]
        }
      end

      it 'returns true' do
        expect(subject.unset(options, access_token: access_token)).to be(true)
      end
    end

    context 'with an unsuccessful response' do
      let(:error_message) { 'Invalid OAuth access token.' }

      before do
        stub_request(:delete, messenger_profile_url)
          .with(query: { access_token: access_token })
          .to_return(
            body: JSON.dump(
              'error' => {
                'message' => error_message,
                'type' => 'OAuthException',
                'code' => 190,
                'fbtrace_id' => 'Hlssg2aiVlN'
              }
            ),
            status: :ok,
            headers: default_graph_api_response_headers
          )
      end

      it 'raises an error' do
        expect do
          options = {
            fields: [
              'get_started'
            ]
          }
          subject.unset(options, access_token: access_token)
        end.to raise_error(Bobot::AccessTokenError)
      end
    end
  end
end
