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

$:.unshift(File.dirname(__FILE__))
require 'test_helper'


class TestGooglePrediction < Test::Unit::TestCase

  def setup
    login = flexmock(:get_token => true, :sign_request! => true)
    flexmock(GData::Auth::ClientLogin).should_receive(:new).and_return(login)

    @srv = flexmock
    flexmock(GData::HTTP::DefaultService).should_receive(:new).and_return(@srv)

    @cls = GooglePrediction::Classifier.new('apiuser@google.com',
                                            'password',
                                            'bucket',
                                            'object.csv')
  end

  def test_predict_success
    body = {'data' => {'output' => {'output_label' => 'label'}}}.to_json
    @srv.should_receive(:make_request).once.and_return(flexmock(:body => body))
    assert @cls.predict('signal')
  end

  def test_predict_exception
    body = {'error' => 'message'}.to_json
    @srv.should_receive(:make_request).once.and_return(flexmock(:body => body))

    assert_raise GooglePrediction::ClassifierException do
      @cls.predict('signal')
    end
  end

  # TODO: improve these tests...
  def test_check
    body = {}.to_json
    @srv.should_receive(:make_request).once.and_return(flexmock(:body => body))
    @cls.check
  end

  def test_train
    body = {}.to_json
    @srv.should_receive(:make_request).once.and_return(flexmock(:body => body))
    @cls.train!
  end

end