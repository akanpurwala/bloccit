class FavoriteMailer < ActionMailer::Base
  default from: "akanpurwala@gmail.com"

  def new_comment(user, post, comment)
    @user = user
    @post = post
    @comment = comment

    # New Headers
    headers["Message-ID"] = "<comments/#{@comment.id}@amir-bloccit.example"
    headers["In-Reply-To"] = "<post/#{@post.id}@amir-bloccit.example"
    headers["References"] = "<post/#{@post.id}@amir-bloccit.example"

    mail(to: user.email, subject: "New Comment on #{post.title}")
  end
end
