class FavoritesController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    authorize! :create, Favorite, message: "You are unable to favorite posts."
    favorite = current_user.favorites.create(post: @post)
    if favorite.valid?
      flash[:notice] = "Favorited post."
      redirect_to [@topic, @post]
    else
      flash[:error] = "Unable to favorite post. Please try again."
      redirect_to [@topic, @post]
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    authorize! :destroy, @favorite, message: "You are unable to unfavorite posts."
    @favorite = current_user.favorites.find(params[:id])

    if @favorite.destroy
      flash[:notice] = "Removed favorite."
      redirect_to [@topic, @post]
    else
      flash[:error] = "Unable to remove favorite. Please try again."
      redirect_to [@topic, @post]
    end
  end
end
