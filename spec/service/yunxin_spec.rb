require 'timecop'
require 'china_sms/service/yunxin'

describe 'Yunxin' do

  describe '#to' do
    let(:username) { 'gyb' }
    let(:password) { '666666' }
    let(:url)      { 'http://h.1069106.com:1210/services/msgsend.asmx/SendMsg' }
    let(:content)  { 'Verify code: 123456' }
    subject { ChinaSMS::Service::Yunxin.to phone, content, username: username, password: password }

    before do
      Timecop.freeze(ChinaSMS::Service::Yunxin::INTERVAL_TIME + 1)
    end

    describe 'send single phone succees' do
      let(:phone) { '13912345678' }
      before do
        stub_request(:post, url).
          with(body: {userCode: username, userPass: password, DesNo: phone,
                      Msg: content, Channel: '0'}).
          to_return(body: '2314357620085030623')
      end

      its([:success]) { is_expected.to be true }
      its([:code])    { is_expected.to eq '2314357620085030623'}
    end

    describe 'send single phone failed' do
      let(:phone) { '13912345678' }
      before do
        stub_request(:post, url).
          with(body: {userCode: username, userPass: password, DesNo: phone,
                      Msg: content, Channel: '0'}).
          to_return(body: '-1')
      end

      its([:success]) { is_expected.to be false }
      its([:code])    { is_expected.to eq  '-1'}
    end

    describe 'send single phone failed' do
      let(:phone) { '13912345678' }
      before do
        stub_request(:post, url).
            with(body: {userCode: username, userPass: password, DesNo: phone,
                        Msg: content, Channel: '0'}).
            to_return(body: '-1')
      end

      its([:success]) { is_expected.to be false }
      its([:code])    { is_expected.to eq  '-1'}
    end

    describe 'send single phone failed because sending interval time too short' do
      let(:phone) { '13912345678' }
      before do
        Timecop.return
      end

      its([:success]) { is_expected.to be false }
      its([:code])    { is_expected.to eq  '-999999'}
    end
  end
end
