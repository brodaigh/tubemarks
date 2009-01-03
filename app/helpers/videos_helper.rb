module VideosHelper
  
  def embed(video)
    "<object width=\"425\" height=\"355\">
    <param name=\"movie\" value=\"http://www.youtube.com/v/#{video}&amp;hl=en\"/>
    <param name=\"wmode\" value=\"opaque\"/>
    </object>
    <object data=\"http://www.youtube.com/v/#{video}&amp;hl=en\" 
    type=\"application/x-shockwave-flash\" width=\"425\" height=\"355\">
    <param name=\"wmode\" value=\"opaque\"/> 
    </object>"
  end
end
