class CommentsController < ApplicationController

  def create
    @comment = Comment.new(params[:comment])
    @video = Video.find(@comment.video_id)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to("/") }
        format.js {render :partial => 'comments' }
      end
    end
  end
end
