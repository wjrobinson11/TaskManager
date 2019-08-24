require 'rails_helper'

RSpec.describe TasksController, type: :request do
  let(:super_admin) { create(:super_admin) }
  let(:company1) { create(:company, name: "Billy Go") }
  let(:task_admin1) { create(:task_admin, email: "task@billygo.com", company_id: company1.id) }
  let(:task1) { create(:task, name: 'Task1', company_id: company1.id) }
  let(:company2) { create(:company, name: "Berkeys") }
  let(:task_admin2) { create(:task_admin, email: "task@berkeys.com", company_id: company2.id) }
  let(:task2) { create(:task, name: 'Task2', company_id: company2.id) }

  before(:each) do
    # load tasks
    task1
    task2
  end

  describe "GET #index" do
    context "when user is a super_admin" do
      before(:each) do
        sign_in(super_admin)
      end

      it "returns a success response" do
        get "/tasks"
        expect(response).to be_successful
      end

      it "returns the index page" do
        get "/tasks"
        expect(response).to render_template(:index)
      end

      it "returns all tasks available" do
        get "/tasks"
        assigns(:tasks).count.should eq(Task.count)
      end
    end

    context "when user is a task_admin" do
      before(:each) do
        sign_in(task_admin1)
      end

      it "returns a success response" do
        get "/tasks"
        expect(response).to be_successful
      end

      it "returns the index page" do
        get "/tasks"
        expect(response).to render_template(:index)
      end

      it "returns only tasks assigned to user's company" do
        get "/tasks"
        assigns(:tasks).count.should eq(company1.tasks.count)
      end
    end
  end

  describe "GET #new" do
    context "when user is a super_admin" do
      before(:each) do
        sign_in(super_admin)
      end

      it "returns a success response" do
        get "/tasks/new"
        expect(response).to be_successful
      end

      it "returns the new page" do
        get "/tasks/new"
        expect(response).to render_template(:new)
      end

      it "returns the company_id form field" do
        get "/tasks/new"
        expect(response.body).to include("task[company_id]")
      end
    end


    context "when user is a task_admin" do
      before(:each) do
        sign_in(task_admin2)
      end

      it "returns a success response" do
        get "/tasks/new"
        expect(response).to be_successful
      end

      it "returns the new page" do
        get "/tasks/new"
        expect(response).to render_template(:new)
      end

      it "does not return the company_id form field" do
        get "/tasks/new"
        expect(response.body).to_not include("task[company_id]")
      end
    end
  end

  describe "GET #edit" do
    context "when user is a super_admin" do
      before(:each) do
        sign_in(super_admin)
      end

      it "returns a success response" do
        get "/tasks/#{task1.id}/edit"
        expect(response).to be_successful
      end

      it "returns the edit page" do
        get "/tasks/#{task1.id}/edit"
        expect(response).to render_template(:edit)
      end

      it "return the company_id form field" do
        get "/tasks/#{task1.id}/edit"
        expect(response.body).to include("task[company_id]")
      end
    end


    context "when user is a task_admin" do
      before(:each) do
        sign_in(task_admin1)
      end

      it "returns a success response" do
        get "/tasks/#{task1.id}/edit"
        expect(response).to be_successful
      end

      it "returns the edit page" do
        get "/tasks/#{task1.id}/edit"
        expect(response).to render_template(:edit)
      end

      it "does not return the company_id form field" do
        get "/tasks/#{task1.id}/edit"
        expect(response.body).to_not include("task[company_id]")
      end

      it "returns a 403 error when requesting a task from another company" do
        get "/tasks/#{task2.id}/edit"
        expect(response.status).to eq(403)
      end
    end
  end

  describe "POST #create" do
    context "when passing valid params" do
      let(:params) do 
        { task: {
          name: "Fix pipes",
          description: "Pipes are leaking underneath sink",
          price: 129
        } }
      end

      before(:each) do
        sign_in(super_admin)
      end

      it "returns a redirect response" do
        post "/tasks", params: params
        expect(response.status).to eq(302)
      end

      it "redirect location is the tasks index path" do
        post "/tasks", params: params
        expect(response).to redirect_to(tasks_url)
      end
    end

    context "when passing invalid params" do
      let(:params) do 
        { task: {
          name: nil,
          description: "Pipes are leaking underneath sink",
          price: 129
        } }
      end

      before(:each) do
        sign_in(super_admin)
      end

      it "returns a success response" do
        post "/tasks", params: params
        expect(response.status).to eq(422)
      end

      it "returns the new page" do
        post "/tasks", params: params
        expect(response).to render_template(:new)
      end
    end

    context "when user is TaskAdmin" do
      let(:params) do 
        { task: {
          name: "Pipe fix",
          description: "Pipes are leaking underneath sink",
          price: 129
        } }
      end

      before(:each) do
        sign_in(task_admin1)
      end

      it "assigns the company associated with the TaskAdmin to the Task" do
        post "/tasks", params: params
        expect(Task.last.company_id).to eq(task_admin1.company_id)
      end

      it "does not allow TaskAdmin to set company_id" do
        params[:task].merge!(company_id: company2.id)
        post "/tasks", params: params
        expect(Task.last.company_id).to_not eq(company2.id)
      end
    end
  end

  describe "PUT #update" do
    context "when passing valid params" do
      let(:params) do 
        { task: {
          name: "Fix pipes",
          description: "Pipes are leaking underneath sink",
          price: 129
        } }
      end

      before(:each) do
        sign_in(super_admin)
      end

      it "returns a redirect response" do
        put "/tasks/#{task1.id}", params: params
        expect(response.status).to eq(302)
      end

      it "redirect location is the tasks index path" do
        put "/tasks/#{task1.id}", params: params
        expect(response).to redirect_to(tasks_url)
      end
    end

    context "when passing invalid params" do
      let(:params) do 
        { task: {
          name: "Fix Pipes",
          description: "Pipes are leaking underneath sink",
          price: nil
        } }
      end

      before(:each) do
        sign_in(super_admin)
      end

      it "returns a success response" do
        put "/tasks/#{task1.id}", params: params
        expect(response.status).to eq(422)
      end

      it "returns the new page" do
        put "/tasks/#{task1.id}", params: params
        expect(response).to render_template(:edit)
      end
    end

    context "when user is TaskAdmin" do
      let(:params) do 
        { task: {
          name: "Pipe fix",
          description: "Pipes are leaking underneath sink",
          price: 129
        } }
      end

      before(:each) do
        sign_in(task_admin1)
      end

      it "does not allow TaskAdmin to set company_id" do
        params[:task].merge!(company_id: company2.id)
        put "/tasks/#{task1.id}", params: params
        expect(task1.reload.company_id).to_not eq(company2.id)
      end

      it "does not allow TaskAdmin to update a task from another company" do
        put "/tasks/#{task2.id}", params: params
        expect(response.status).to eq(403)
      end
    end
  end


  describe "DELETE #destroy" do
    context "when user is a SuperAdmin" do
      before(:each) do
        sign_in(super_admin)
      end

      it "destroys the requested task" do
        expect {
          delete "/tasks/#{task1.id}"
        }.to change(Task, :count).by(-1)
      end

      it "redirects to the tasks list" do
        delete "/tasks/#{task1.id}"
        expect(response).to redirect_to(tasks_url)
      end
    end
    
    context "when user is a TaskAdmin" do
      before(:each) do
        sign_in(task_admin1)
      end

      it "destroys the requested task" do
        expect {
          delete "/tasks/#{task1.id}"
        }.to change(Task, :count).by(-1)
      end

      it "does not let user destroy tasks belonging to another company" do
        expect {
          delete "/tasks/#{task2.id}"
        }.to change(Task, :count).by(0)
      end
    end
  end

end
