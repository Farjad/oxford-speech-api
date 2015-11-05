require 'rest-client'
require 'securerandom'
require 'json'

class OxfordSpeechApi
  def initialize(client, secret)
    @client = client
    @secret = secret
  end

  def speech2text(file, codec, rate)
    params = {
        :scenarios => 'ulm',
        :appID => 'D4D52672-91D7-4C74-8AD8-42B1D98141A5',
        :locale => 'en-US',
        'device.os' => 'Oxford Speech Client',
        :version => '3.0',
        :format => 'json',
        :requestid => SecureRandom.uuid,
        :instanceid => SecureRandom.uuid
    }
    data = File.read(file)
    headers = {
        :content_type => codec.to_s + '; samplerate=' + rate.to_s,
        :content_length => data.size,
        :authorization => 'Bearer ' + get_access_token
    }
    response = RestClient.post 'https://speech.platform.bing.com/recognize/query?' + URI.encode_www_form(params), data, headers
    JSON.parse(response)
  end

  def text2speech(text)
    headers = {
        :content_type => 'application/ssml+xml',
        'X-Microsoft-OutputFormat' => 'riff-8khz-8bit-mono-mulaw',
        'X-Search-AppId' => SecureRandom.uuid.gsub(/[^0-9a-z ]/i, ''),
        'X-Search-ClientID' => SecureRandom.uuid.gsub(/[^0-9a-z ]/i, ''),
        :user_agent => @client,
        'X-Search-PartnerEventID' => SecureRandom.uuid.gsub(/[^0-9a-z ]/i, ''),
        :authorization => 'Bearer ' + get_access_token
    }

    data = "<speak version='1.0' xml:lang='en-US'><voice xml:lang='en-US' xml:gender='Female' name='Microsoft Server Speech Text to Speech Voice (en-US, ZiraRUS)'>" + text + "</voice></speak>"
    response = RestClient.post 'https://speech.platform.bing.com/synthesize', data, headers
  end

  private

  def get_access_token
    params = {
        :grant_type => 'client_credentials',
        :client_id => @client,
        :client_secret => @secret,
        :scope => 'https://speech.platform.bing.com'
    }
    response = RestClient.post 'https://oxford-speech.cloudapp.net/token/issueToken', params
    json = JSON.parse(response)

    json['access_token']
  end
end