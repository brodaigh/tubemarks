module VideosHelper
  
  def embed(video)
    
    "<object width=\"425\" height=\"355\"><param name=\"movie\" 
    value=\"http://www.youtube.com/v/#{video}&hl=en\"></param><param name=\"wmode\" 
    value=\"transparent\"></param><embed src=\"http://www.youtube.com/v/#{video}&hl=en\" t
    ype=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"425\" height=\"355\"></embed></object>"
  end
  
end
