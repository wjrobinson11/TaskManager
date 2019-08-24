require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:super_admin) { create(:super_admin) }
  let(:company1) { create(:company, name: "Billy Go") }
  let(:task_admin1) { create(:task_admin, email: "task@billygo.com", company_id: company1.id) }
  let(:company2) { create(:company, name: "Berkeys") }
  let(:task_admin2) { create(:task_admin, email: "task@berkeys.com", company_id: company2.id) }

  before(:each) do
    # load users
    super_admin
    task_admin1
    task_admin1
  end

  describe "GET #index" do
    context "when user is a super_admin" do
      before(:each) do
        sign_in(super_admin)
      end

      it "returns a success response" do
        get "/users"
        expect(response).to be_successful
      end

      it "returns the index page" do
        get "/users"
        expect(response).to render_template(:index)
      end

      it "returns all TaskAdmin users" do
        get "/users"
        assigns(:users).length.should eq(TaskAdmin.count)
      end
    end

    context "when user is a task_admin" do
      it "returns a 403 error" do
        sign_in(task_admin1)
        get "/users"
        expect(response.status).to eq(403)
      end
    end
  end

  describe "GET #new" do
    context "when user is a super_admin" do
      before(:each) do
        sign_in(super_admin)
      end

      it "returns a success response" do
        get "/users/new"
        expect(response).to be_successful
      end

      it "returns the new page" do
        get "/users/new"
        expect(response).to render_template(:new)
      end
    end

    context "when user is a task_admin" do
      it "returns a 403 error" do
        sign_in(task_admin1)
        get "/users/new"
        expect(response.status).to eq(403)
      end
    end
  end

  describe "GET #edit" do
    context "when user is a super_admin" do
      before(:each) do
        sign_in(super_admin)
      end

      it "returns a success response" do
        get "/users/#{task_admin1.id}/edit"
        expect(response).to be_successful
      end

      it "returns the edit page" do
        get "/users/#{task_admin1.id}/edit"
        expect(response).to render_template(:edit)
      end
    end

    context "when user is a task_admin" do
      it "returns a 403 error" do
        get "/users/#{task_admin1.id}/edit"
        expect(response.status).to eq(403)
      end
    end
  end

  describe "POST #create" do
    context "when passing valid params" do
      let(:params) do 
        { user: {
          email: "task@companyname.com",
          password: "password",
          password_confirmation: "password",
          company_id: company2.id
        } }
      end

      before(:each) do
        sign_in(super_admin)
      end

      it "returns a redirect response" do
        post "/users", params: params
        expect(response.status).to eq(302)
      end

      it "redirect location is the users index path" do
        post "/users", params: params
        expect(response).to redirect_to(users_url)
      end
    end

    context "when passing invalid params" do
      let(:params) do 
        { user: {
          email: "task@companyname.com",
          password: "password",
          password_confirmation: "",
          company_id: company2.id
        } }
      end

      before(:each) do
        sign_in(super_admin)
      end

      it "returns a success response" do
        post "/users", params: params
        expect(response.status).to eq(422)
      end

      it "returns the new page" do
        post "/users", params: params
        expect(response).to render_template(:new)
      end
    end

    context "when user is TaskAdmin" do
      let(:params) do 
        { user: {
          email: "task@companyname.com",
          password: "password",
          password_confirmation: "password",
          company_id: company2.id
        } }
      end

      it "returns a 403 error" do
        post "/users", params: params
        expect(response.status).to eq(403)
      end
    end
  end

  describe "PUT #update" do
    context "when passing valid params" do
      let(:params) do 
        { user: {
          email: "task@companyname.com",
          password: "password",
          password_confirmation: "password",
          company_id: company2.id
        } }
      end

      before(:each) do
        sign_in(super_admin)
      end

      it "returns a redirect response" do
        put "/users/#{task_admin1.id}", params: params
        expect(response.status).to eq(302)
      end

      it "redirect location is the users index path" do
        put "/users/#{task_admin1.id}", params: params
        expect(response).to redirect_to(users_url)
      end
    end

    context "when passing invalid params" do
      let(:params) do 
        { user: {
          email: "task",
          password: "password",
          password_confirmation: "password",
          company_id: company2.id
        } }
      end

      before(:each) do
        sign_in(super_admin)
      end

      it "returns a success response" do
        put "/users/#{task_admin1.id}", params: params
        expect(response.status).to eq(422)
      end

      it "returns the new page" do
        put "/users/#{task_admin1.id}", params: params
        expect(response).to render_template(:edit)
      end
    end

    context "when user is TaskAdmin" do
      let(:params) do 
        { user: {
          email: "task@companyname.com",
          password: "password",
          password_confirmation: "password",
          company_id: company2.id
        } }
      end

      it "returns a 403 error" do
        put "/users/#{task_admin1.id}", params: params
        expect(response.status).to eq(403)
      end
    end
  end


  describe "DELETE #destroy" do
    context "when user is a SuperAdmin" do
      before(:each) do
        sign_in(super_admin)
      end

      it "destroys the requested user" do
        expect {
          delete "/users/#{task_admin1.id}"
        }.to change(User, :count).by(-1)
      end

      it "redirects to the users index" do
        delete "/users/#{task_admin1.id}"
        expect(response).to redirect_to(users_url)
      end
    end
    
    context "when user is a TaskAdmin" do
      it "returns a 403 error" do
        delete "/users/#{task_admin1.id}"
        expect(response.status).to eq(403)
      end
    end
  end

end
