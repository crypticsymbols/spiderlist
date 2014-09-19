class FeedbackController < ApplicationController

  def create
    params[:feedback][:email] = current_user.email

    @message = Feedback.new(params[:feedback])

    if @message.valid?
      FeedbackMailer.new_feedback(@message).deliver
      redirect_to(root_path, :notice => "Message was successfully sent.")
    else
      flash[:notice] = 'Please enter a message.'
      render :new
    end
  end
end
