describe Admin::EnrollmentsController do

  describe '#new' do
    it "renders the 'new' template" do
      get :new

      expect(response).to render_template 'new'
    end
  end

  describe '#create' do
    let(:csv_file)      { File.open Rails.root + 'spec/support/fixtures/enrollment.csv' }
    let(:file_upload)   { ActionDispatch::Http::UploadedFile.new(filename: 'enrollment.csv',
                                                                 type:     'text/csv',
                                                                 tempfile:  csv_file)}
    it 'processes a new Enrollment' do
      expect(Enrollment).to receive(:process!).with csv_file

      post :create, enrollment_file: file_upload
    end

    it 'redirects to the new enrollment form' do
      Enrollment.stub(:process!).and_return true

      post :create, enrollment_file: file_upload

      expect(response).to redirect_to new_admin_enrollment_path
    end
  end
end
