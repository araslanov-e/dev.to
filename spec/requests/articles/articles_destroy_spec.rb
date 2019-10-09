describe "ArticlesDestroy", type: :request do
  let(:user) { create(:user, :org_admin) }
  let(:article) { create(:article, user_id: user.id) }

  before do
    sign_in user
  end

  it "destroyes an article" do
    delete "/articles/#{article.id}"
    destroyed_article = Article.find_by(id: article.id)
    expect(destroyed_article).to be_nil
  end

  it "schedules a RemoveAllJob if there are comments" do
    create(:comment, commentable: article, user: user)
    expect do
      delete "/articles/#{article.id}"
    end.to have_enqueued_job(Notifications::RemoveAllJob).once
  end

  it "removes all previous published notifications" do
    create(:notification, notifiable: article, action: "Published", user: user)
    expect do
      delete "/articles/#{article.id}"
    end.to change(Notification, :count).by(-1)
  end

  it "doesn't destroy another person's article" do
    article2 = create(:article, user_id: create(:user).id)
    expect do
      delete "/articles/#{article2.id}"
    end.to raise_error(Pundit::NotAuthorizedError)
  end
end
