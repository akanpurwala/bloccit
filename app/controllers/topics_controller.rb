class TopicsController < ApplicationController
  def index
    @topics = Topic.all
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(params[:topic])
    authorize! :create, @topic, message: "You must be an admin to create topics."
    if @topic.save
      redirect_to @topic, notice: "Topic was saved successfully."
    else
      flash[:error] = "Error creating topic. Please try again."
      render :new
    end
  end 

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts
  end

  def edit
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "You must be an admin to edit topics."
  end

  def update
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "You must be an admin to edit topics."
    if @topic.update_attributes(params[:topic])
      redirect_to @topic, notice: "Topic was edited successfully."
    else
      flash[:error] = "Error editing topic. Please try again."
      render :edit
    end
  end
end
