module ChinaSMS::Service::Yunxin
  extend self

  URL = 'http://h.1069106.com:1210/services/msgsend.asmx/SendMsg'

  def to(phone, content, options)
    res = Net::HTTP.post_form(URI.parse(URL),
                              userCode: options[:username],
                              userPass: options[:password],
                              DesNo: phone,
                              Msg: content,
                              Channel: 0)
    result res.body
  end

  def result(body)
    {
      success: (body.to_i >= 0),
      code: body
    }
  end
  
end
