# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
        format.json { render :show, status: :created, location: @comment }
      else
        @comments = @commentable.comments.preload(:user).order(created_at: :desc)
        format.html { render_commentable }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human) }
      format.json { head :no_content }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end
end
