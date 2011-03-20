# Copyright (C) 2010 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'rubygems'
require 'gdata'
require 'active_support'
require 'active_support/json'

module GooglePrediction

  # Base class for all exceptions raised by the classifier.
  class ClassifierException < StandardError
  end

  # the Classifier class encapsulates one predictive model.
  class Classifier
    HEADERS = {'Content-Type' => 'application/json'}

    # Create a new Classifier.
    #
    # Args:
    #  - login: your google login (passed to GData)
    #  - password: your google password.
    #  - bucket: the Google Storage bucket where the training data lives.
    #  - object: the name of the training data, including file extension.
    #
    def initialize(login, password, bucket, object)

      # Use the GData gem to authenticate over HTTP.
      @login = GData::Auth::ClientLogin.new('xapi')
      @login.get_token(login, password, '')

      @service = GData::HTTP::DefaultService.new
      @bucket = bucket
      @object = object
      @base_uri = "https://www.googleapis.com/prediction/v1/training"
      @model = "#{@bucket}%2F#{@object}"
    end

    # Send a request to start training on the model in @bucket/@object.
    #
    # Returns:
    #   Hash of response from server. See web API documentation.
    #
    def train!
      body = {:data => {}}.to_json
      req = GData::HTTP::Request.new(@base_uri + '?data=' + @model,
                {:method => :post, :body => body, :headers => HEADERS})
      sign_and_request(req)
    end

    # Send a check request for the status/accuracy of the model.
    #
    # Returns:
    #   A hash with information about the model. See web API documentation.
    #
    def check
      req = GData::HTTP::Request.new(@base_uri + '/' + @model)
      sign_and_request(req)
    end

    # Send a predict request to the API.
    #
    # Args:
    #  - signals: a variable number of text and numeric features.
    #
    # Returns:
    #  - The output label as a String.
    #
    # Raises:
    #  - ClassifierException. Catch this and wait/retry if hitting rate limit.
    #
    def predict(*signals)
      body = {:data => {:input => {:text => [signals]}}}.to_json
      req = GData::HTTP::Request.new(@base_uri + '/' + @model + "/predict",
                {:method => :post, :body => body, :headers => HEADERS})
      hsh = sign_and_request(req)

      return hsh['data']['output']['output_label'] if hsh['data']
      if hsh['error']
        raise ClassifierException, hsh['error']['message']
      end
    end

    private

    # Signs an HTTP request using the auth token and make the request.
    #
    # Args:
    #  - req: a GData::HTTP::Request object.
    #
    # Returns:
    #  - a hash representing the response body.
    #
    def sign_and_request(req)
      @login.sign_request!(req)
      ActiveSupport::JSON.decode(@service.make_request(req).body)
    end

  end

end