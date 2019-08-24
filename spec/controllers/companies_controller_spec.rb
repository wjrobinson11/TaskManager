require 'rails_helper'

RSpec.describe CompaniesController, type: :request do
  let(:super_admin) { create(:super_admin) }
  let(:company1) { create(:company, name: "Billy Go") }
  let(:task_admin1) { create(:task_admin, email: "task@billygo.com", company_id: company1.id) }
  let(:company2) { create(:company, name: "Berkeys") }
  let(:task_admin2) { create(:task_admin, email: "task@berkeys.com", company_id: company2.id) }

  before(:each) do
    # load companies
    company1
    company2
  end

  describe "GET #index" do
    context "when user is a super_admin" do
      before(:each) do
        sign_in(super_admin)
      end

      it "returns a success response" do
        get "/companies"
        expect(response).to be_successful
      end

      it "returns the index page" do
        get "/companies"
        expect(response).to render_template(:index)
      end

      it "returns all Companies available" do
        get "/companies"
        assigns(:companies).length.should eq(Company.count)
      end

      it "returns task_count and task_admin_count for companies" do
        get "/companies"
        expect(assigns(:companies).sample).to respond_to(:task_admin_count, :task_count)
      end
    end

    context "when user is a task_admin" do
      it "returns a 403 error" do
        sign_in(task_admin1)
        get "/companies"
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
        get "/companies/new"
        expect(response).to be_successful
      end

      it "returns the new page" do
        get "/companies/new"
        expect(response).to render_template(:new)
      end
    end

    context "when user is a task_admin" do
      it "returns a 403 error" do
        sign_in(task_admin1)
        get "/companies/new"
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
        get "/companies/#{company1.id}/edit"
        expect(response).to be_successful
      end

      it "returns the edit page" do
        get "/companies/#{company1.id}/edit"
        expect(response).to render_template(:edit)
      end
    end


    context "when user is a task_admin" do
      before(:each) do
        sign_in(task_admin1)
      end

      it "returns a 403 error" do
        get "/companies/#{company1.id}/edit"
        expect(response.status).to eq(403)
      end
    end
  end

  describe "POST #create" do
    context "when passing valid params" do
      let(:params) do 
        { company: {
          name: "Company A"
        } }
      end

      before(:each) do
        sign_in(super_admin)
      end

      it "returns a redirect response" do
        post "/companies", params: params
        expect(response.status).to eq(302)
      end

      it "redirect location is the companies index path" do
        post "/companies", params: params
        expect(response).to redirect_to(companies_url)
      end
    end

    context "when passing invalid params" do
      let(:params) do 
        { company: {
          name: nil
        } }
      end

      before(:each) do
        sign_in(super_admin)
      end

      it "returns a success response" do
        post "/companies", params: params
        expect(response.status).to eq(422)
      end

      it "returns the new page" do
        post "/companies", params: params
        expect(response).to render_template(:new)
      end
    end

    context "when user is TaskAdmin" do
      let(:params) do 
        { company: {
          name: "Pipe fix"
        } }
      end

      before(:each) do
        sign_in(task_admin1)
      end

      it "returns a 403 error" do
        post "/companies", params: params
        expect(response.status).to eq(403)
      end
    end
  end

  describe "PUT #update" do
    context "when passing valid params" do
      let(:params) do 
        { company: {
          name: "Fix pipes"
        } }
      end

      before(:each) do
        sign_in(super_admin)
      end

      it "returns a redirect response" do
        put "/companies/#{company1.id}", params: params
        expect(response.status).to eq(302)
      end

      it "redirect location is the companies index path" do
        put "/companies/#{company1.id}", params: params
        expect(response).to redirect_to(companies_url)
      end
    end

    context "when passing invalid params" do
      let(:params) do 
        { company: {
          name: nil
        } }
      end

      before(:each) do
        sign_in(super_admin)
      end

      it "returns a success response" do
        put "/companies/#{company1.id}", params: params
        expect(response.status).to eq(422)
      end

      it "returns the new page" do
        put "/companies/#{company1.id}", params: params
        expect(response).to render_template(:edit)
      end
    end

    context "when user is TaskAdmin" do
      let(:params) do 
        { company: {
          name: "Pipe fix"
        } }
      end

      before(:each) do
        sign_in(task_admin1)
      end

      it "returns a 403 error" do
        put "/companies/#{company1.id}", params: params
        expect(response.status).to eq(403)
      end
    end
  end


  describe "DELETE #destroy" do
    context "when user is a SuperAdmin" do
      before(:each) do
        sign_in(super_admin)
      end

      it "destroys the requested company" do
        expect {
          delete "/companies/#{company1.id}"
        }.to change(Company, :count).by(-1)
      end

      it "redirects to the companies index path" do
        delete "/companies/#{company1.id}"
        expect(response).to redirect_to(companies_url)
      end
    end
    
    context "when user is a TaskAdmin" do
      before(:each) do
        sign_in(task_admin1)
      end

      
      it "returns a 403 error" do
        delete "/companies/#{company1.id}"
        expect(response.status).to eq(403)
      end
    end
  end

end
