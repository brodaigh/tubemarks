module VideosHelper
  
  def embed(video)
    "<object data=\"http://www.youtube.com/v/#{video}&amp;hl=en\" 
    type=\"application/x-shockwave-flash\" width=\"425\" height=\"355\">
    <param name=\"movie\" value=\"http://www.youtube.com/v/#{video}&amp;hl=en\"/>
    <param name=\"wmode\" value=\"transparent\"/>
    <param name=\"allowFullScreen\" value=\"true\"></param>
    </object>"
  end
end

