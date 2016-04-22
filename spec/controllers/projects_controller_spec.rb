require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_id(user)
  end

  if "displays an error for a mission project" do
    get :show, id: "not-here"

    expect(response).to redirect_to(projects_path)
    message = "The project you were looking for could not be found."
  end

  context "standard users" do
    before do
      sign_in(user)
    end

    {
      new: :get,
      create: :post,
      edit: :get,
      update: :put,
      destroy: :delete
    }.each do |action, method|

    it "cannot access the new action" do
      get :new

      expect(response).to redirect_to('/')
      expect(flash[:alert]).to eql("You must be an admin to do that.")
    end
  end

  it "displays an error for a missing project" do
    get :show, id: "not-here"
    expect(response).to redirect_to(project_path)
    message = "The project you were looking for could not be found."
    expect(flash[:alert]).to eql(message)
  end

  it "cannot access the #{action} action" do
    sign_in(user)
    send(method, action, :id => FactoryGirl.create(:project))
    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eql("You must be an admin to do that.")
  end

  it "cannot access the show action without permission" do
    project = FactoryGirl.create(:project)
    get :show, id: project.id

    expect(response).to redirect_to(projects_path)
    expect(flash[:alert]).to eql("The project you were looking " +
                        "for could not be found.")
  end
end
