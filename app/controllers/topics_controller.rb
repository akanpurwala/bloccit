class TopicsController < ApplicationController
  def index
    @topics = Topic.visible_to(current_user).paginate(page: params[:page], per_page: 10)
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
    @posts = @topic.posts.paginate(page: params[:page], per_page: 10)
    authorize! :read, @topic, message: "You need to be signed-in to do that!"
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

  def destroy
    @topic = Topic.find(params[:id])
    authorize! :destroy, @topic, message: "You must be an admin to delete topics."
    name = @topic.name
    if @topic.destroy
      flash[:notice] = "\"#{name}\" was deleted successfully."
      redirect_to topics_path
    else
      flash[:error] = "There was an error deleting the topic."
      render :show
    end
  end

end
