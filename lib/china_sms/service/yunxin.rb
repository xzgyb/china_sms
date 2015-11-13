module ChinaSMS::Service
  module Yunxin
    extend self

    URL = 'http://h.1069106.com:1210/services/msgsend.asmx/SendMsg'
    INTERVAL_TIME = 60  # 60 seconds for send sms interval time.

    def to(phone, content, options)
      send_with_block do
        res = Net::HTTP.post_form(URI.parse(URL),
                                  userCode: options[:username],
                                  userPass: options[:password],
                                  DesNo: phone,
                                  Msg: content,
                                  Channel: 0)
        result res.body
      end
    end

    private

    def send_with_block
      @last_send_time ||= Time.at(0)
      if (Time.now - @last_send_time) > INTERVAL_TIME
        result = yield
        @last_send_time = Time.now
        result
      else
        {
            success: false,
            code: "-999999"      #code -999999 indicates that sending failed is
                                 # because interval time too short.
        }
      end

    end

    def result(body)
      code = body.match(/<string.+>(.+)<\/string/)[1]
      {
        success: (code.to_i >= 0),
        code: code
      }
    end
  end
    
end
