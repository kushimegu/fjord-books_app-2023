# frozen_string_literal: true

class CommentsController < ApplicationController

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html do
          redirect_to polymorphic_path([@comment.commentable, @comment]), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
        end
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html do
        redirect_to polymorphic_path([@comment.commentable, @comment]), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
      end
      format.json { head :no_content }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id)
  end

  def find_commentable
    params.each do |name, value|
      return ::Regexp.last_match(1).classify.constantize.find(value) if name =~ /(.+)_id$/
    end
    nil
  end
end
